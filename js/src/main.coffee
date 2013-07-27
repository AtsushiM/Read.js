do () ->
    win = window
    doc = document
    required_obj = {}
    sequence = []

    errorNotFound = (required) ->
        throw Error 'not found ' + required

    dispLog = () ->
        if window.console
            console.log.apply console, arguments

    presenceCheck = (required) ->
        temp = win

        for val in required.split('.')
            temp = temp[val]

            if !temp
                break

        return temp

    read = (required, srcpath) ->
        cls = presenceCheck required

        if !cls
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath] = true

                srcpath += '.js'

                xhr = new XMLHttpRequest

                xhr.onreadystatechange = ->
                    if xhr.readyState == 4
                        if xhr.status == 200
                            doc.head.appendChild(script = doc.createElement 'script')
                            script.text = '// src: ' + srcpath + '.js\n' + xhr.responseText

                            dispLog srcpath, script
                            sequence.push srcpath
                        else
                            throw Error 'file load error: ' + required

                    return

                xhr.open 'GET', srcpath + '?t=' + (+new Date), false

                xhr.send()
            else
                errorNotFound required

        unless cls = presenceCheck required
            errorNotFound required

        return cls

    read['orderLog'] = () ->
        log = ''

        for val in sequence
            log += val + ' '

        dispLog log

        return sequence

    win['read'] = read

    return
