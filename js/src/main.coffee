do () ->
    win = window
    doc = document
    required_obj = {}
    sequence = []

    errorNotFound = (required) ->
        throw Error 'not found ' + required

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

    read['ns'] = (keywords, swap) ->
        keywords = keywords.split('.')
        i = 0
        len = keywords.length
        temp = win

        while i < len
            if !temp[keywords[i]]
                break

            par = temp
            temp = temp[keywords[i]]

            i++

        while i < len
            par = temp
            temp = temp[keywords[i]] = {}

            i++

        if swap
            for i, val of temp
                if swap[i] == undefined
                    swap[i] = val

            par[keywords[(len - 1)]] = swap

            temp = swap

        return temp

    read['orderLog'] = () ->
        log = ''

        for val in sequence
            log += val + ' '

        return sequence

    win['read'] = read

    return
