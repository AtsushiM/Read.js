do (
    win = window,
    doc = document,
    required_obj = {},
    reg_readmethod = /[=,;:&\n\(\|]\s*read\(.+?,\s*['"](.+?)['"]\)/
    errorNotFound = ((required) ->
        throw Error 'not found ' + required

        return
    ),
    time = +new Date
) ->
    srcpathNoCache = (srcpath) ->
        return srcpath + '?t=' + time
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
            .appendChild(doc.createElement 'script')
            .text = '//src:' +
                srcpath +
                getFile srcpath

        return

    (read = win['read'] = (required, srcpath) ->
        unless cls = checkPersence required
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath += '.js'] = true

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
            break unless temp[keywords[i]]

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
        loaded_paths = {}
        unitefile = ''

        checkReadLoop = (jspath) ->
            require_ary.unshift jspath

            unless required_obj[jspath]
                required_obj[jspath] = 1

                getFile jspath, (filevalue) ->
                    unitefile = filevalue + unitefile

                    if result = unitefile.match reg_readmethod
                        temp = result[1] + '.js'

                        unitefile = unitefile.slice result.index + result[0].length

                        require_ary.unshift temp

                        return checkReadLoop temp

                    loadLoop()

                    return

            return

        loadLoop = () ->
            if src = require_ary.shift()
                unless loaded_paths[src]
                    loaded_paths[src] = 1
                    script = doc.createElement 'script'
                    loadaction = () ->
                        script.removeEventListener 'load', loadaction
                        loadLoop()

                        return

                    script.addEventListener 'load', loadaction

                    script.src = srcpathNoCache(src)

                    doc.head.appendChild script
                else
                    loadLoop()

            return

        checkReadLoop path

        return

    return
