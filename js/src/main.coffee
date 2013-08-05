do (
    win = window,
    doc = document,
    required_obj = {},
    reg_readmethod = /([\n=,;:\(&\|])\s*read\(.+?,\s*['"](.+?)['"]\)/
    errorNotFound = ((required) ->
        throw Error 'not found ' + required

        return
    )
) ->
    presenceCheck = (required) ->
        required = required.split('.')
        temp = win

        for i of required
            temp = temp[required[i]]

            break unless temp

        return temp

    xhrGet = (srcpath) ->
        res = ''
        xhr = new XMLHttpRequest

        xhr.onreadystatechange = ->
            if xhr.readyState == 4
                if xhr.status == 200
                    res = xhr.responseText
                else
                    errorNotFound srcpath

            return

        xhr.open 'GET', srcpath + '?t=' + new Date*1, false

        xhr.send()

        return '\n' + res.replace /\r\n?/g, '\n'

    xhrSyncScriptLoad = (srcpath) ->
        res = xhrGet srcpath

        doc.head
            .appendChild(doc.createElement 'script')
            .text = '//src:' + srcpath + res

        return

    (read = win['read'] = (required, srcpath) ->
        cls = presenceCheck required

        unless cls
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath] = true

                srcpath += '.js'

                xhrSyncScriptLoad srcpath
            else
                errorNotFound required

        unless cls = presenceCheck required
            errorNotFound required

        return cls
    )['ns'] = (keywords, swap) ->
        keywords = keywords.split '.'
        i = 0
        len = keywords.length
        temp = win

        while i < len
            break if !temp[keywords[i]]

            par = temp
            temp = temp[keywords[i]]

            i++

        while i < len
            par = temp
            temp = temp[keywords[i]] = {}

            i++

        if swap
            for i of temp
                if swap[i] == undefined
                    swap[i] = temp[i]

            temp = par[keywords[(len - 1)]] = swap

        return temp

    read['run'] = (path) ->
        path = path + '.js'
        require_ary = []

        checkReadLoop = (jspath) ->
            filevalue = xhrGet jspath

            while result = filevalue.match reg_readmethod
                temp = result[2] + '.js'

                unless required_obj[temp]
                    checkReadLoop temp

                filevalue = filevalue.slice result.index + result[0].length

            require_ary.push jspath
            required_obj[jspath] = true

            return

        checkReadLoop path

        loadLoop = () ->
            if src = require_ary.shift()
                script = doc.createElement 'script'
                loadaction = () ->
                    script.removeEventListener 'load', loadaction
                    loadLoop()

                    return

                script.addEventListener 'load', loadaction

                script.src = src

                doc.head.appendChild script

            return

        loadLoop()

        return

    return
