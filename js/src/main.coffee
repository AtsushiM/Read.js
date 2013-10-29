do (
    win = window,
    doc = document,
    required_obj = {},
    reg_readmethod = /[=,;:&\n\(\|]\s*read\(.+?,\s*['"](.+?)['"]\)/
    time = '?' + new Date * 1,
    ev = 'load',
    tag = 'script',
    ext = '.js'
) ->
    errorNotFound = (required) ->
        throw Error 'not found ' + required

        return

    srcpathNoCache = (srcpath) ->
        return srcpath + time

    checkPersence = (required) ->
        required = required.split('.')
        temp = win

        for i of required
            temp = temp[required[i]]

            break unless temp

        return temp

    getFile = (srcpath, callback) ->
        res = ''
        xhr = new XMLHttpRequest

        xhr.onreadystatechange = ->
            if xhr.readyState == 4
                if xhr.status == 200
                    res = '\n' + xhr.responseText
                else
                    errorNotFound srcpath

                callback res if callback
            return

        xhr.open 'GET', srcpathNoCache(srcpath), !!callback

        xhr.send()

        return res

    xhrSyncScriptLoad = (srcpath) ->
        doc.head
            .appendChild(doc.createElement tag)
            .text = getFile srcpath

        return

    (read = win['read'] = (required, srcpath) ->
        unless cls = checkPersence required
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath += ext] = true

                xhrSyncScriptLoad srcpath
            else
                errorNotFound required

        unless cls = checkPersence required
            errorNotFound required

        return cls
    )['ns'] = (keywords, swap) ->
        keywords = keywords.split '.'
        i = 0
        len = keywords.length
        temp = win

        while i < len
            par = temp

            if temp[keywords[i]]
                temp = temp[keywords[i]]
            else
                temp = temp[keywords[i]] = {}

            i++

        if swap
            for i of temp
                if swap[i] == undefined
                    swap[i] = temp[i]

            temp = par[keywords[(len - 1)]] = swap

        return temp

    read['run'] = (path) ->
        path = path + ext
        require_ary = []
        loaded_paths = {}
        unitefile = ''

        checkReadLoop = (jspath) ->
            require_ary.unshift jspath

            unless required_obj[jspath]
                required_obj[jspath] = 1

                if !jspath.match /^(\/\/|http)/
                    console.log(jspath);
                    getFile jspath, (filevalue) ->
                        unitefile = filevalue + unitefile
                        nextRead filevalue

                        return
                else
                    console.log(jspath);
                    require_ary.unshift jspath

                    nextRead filevalue


            return

        nextRead = (filevalue) ->
            if result = unitefile.match reg_readmethod
                temp = result[1] + ext

                unitefile = unitefile.slice result.index + result[0].length

                require_ary.unshift temp

                return checkReadLoop temp

            loadLoop()

        loadLoop = () ->
            if src = require_ary.shift()
                unless loaded_paths[src]
                    loaded_paths[src] = 1
                    script = doc.createElement tag
                    loadaction = () ->
                        script.removeEventListener ev, loadaction
                        loadLoop()

                        return

                    script.addEventListener ev, loadaction

                    script.src = srcpathNoCache(src)

                    doc.head.appendChild script
                else
                    loadLoop()

            return

        checkReadLoop path

        return

    return
