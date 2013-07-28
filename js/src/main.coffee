do (
    win = this,
    doc = document,
    required_obj = {},
    sequence = [],
    errorNotFound = ((required) ->
        throw Error 'not found ' + required
    )
) ->

    presenceCheck = (required) ->
        required = required.split('.')
        temp = win

        for i of required
            temp = temp[required[i]]

            if !temp
                break

        return temp

    (read = win['read'] = (required, srcpath) ->
        cls = presenceCheck required

        if !cls
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath] = true

                srcpath += '.js'

                xhr = new XMLHttpRequest

                xhr.onreadystatechange = ->
                    if xhr.readyState == 4
                        if xhr.status == 200
                            doc.head
                                .appendChild(doc.createElement 'script')
                                .text = '//src:' + srcpath + '\n' + xhr.responseText

                            sequence.push srcpath
                        else
                            errorNotFound srcpath

                    return

                xhr.open 'GET', srcpath + '?t=' + new Date*1, false

                xhr.send()
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
            for i of temp
                if swap[i] == undefined
                    swap[i] = temp[i]

            temp = par[keywords[(len - 1)]] = swap

        return temp

    read['orderLog'] = () ->
        return sequence

    return
