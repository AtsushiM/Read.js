do () ->
    win = window
    doc = document
    required_obj = {}

    errorNotFound = (required) ->
        throw Error 'not found ' + required

    presenceCheck = (required) ->
        temp = win

        for val in required.split('.')
            temp = temp[val]

            if !temp
                break

        return temp

    win['read'] = (required, srcpath) ->
        cls = presenceCheck required

        if !cls
            if srcpath && !required_obj[srcpath]
                required_obj[srcpath] = true

                xhr = new XMLHttpRequest

                xhr.onreadystatechange = ->
                    if xhr.readyState == 4
                        if xhr.status == 200
                            doc.head.appendChild(script = doc.createElement 'script')
                            script.text = xhr.responseText
                        else
                            throw Error 'file load error: ' + required

                    return

                xhr.open 'GET', srcpath + '.js?t=' + (+new Date), false

                xhr.send()
            else
                errorNotFound required

        unless cls = presenceCheck required
            errorNotFound required

        return cls

    return
