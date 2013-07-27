// Generated by CoffeeScript 1.6.3
(function(win, doc, required_obj, sequence, errorNotFound) {
  var presenceCheck, read;
  presenceCheck = function(required) {
    var i, temp;
    required = required.split('.');
    temp = win;
    for (i in required) {
      temp = temp[required[i]];
      if (!temp) {
        break;
      }
    }
    return temp;
  };
  (read = win['read'] = function(required, srcpath) {
    var cls, xhr;
    cls = presenceCheck(required);
    if (!cls) {
      if (srcpath && !required_obj[srcpath]) {
        required_obj[srcpath] = true;
        srcpath += '.js';
        xhr = new XMLHttpRequest;
        xhr.onreadystatechange = function() {
          if (xhr.readyState === 4) {
            if (xhr.status === 200) {
              doc.head.appendChild(doc.createElement('script')).text = '//src:' + srcpath + '\n' + xhr.responseText;
              sequence.push(srcpath);
            } else {
              errorNotFound(srcpath);
            }
          }
        };
        xhr.open('GET', srcpath + '?t=' + new Date * 1, false);
        xhr.send();
      } else {
        errorNotFound(required);
      }
    }
    if (!(cls = presenceCheck(required))) {
      errorNotFound(required);
    }
    return cls;
  })['ns'] = function(keywords, swap) {
    var i, len, par, temp;
    keywords = keywords.split('.');
    i = 0;
    len = keywords.length;
    temp = win;
    while (i < len) {
      if (!temp[keywords[i]]) {
        break;
      }
      par = temp;
      temp = temp[keywords[i]];
      i++;
    }
    while (i < len) {
      par = temp;
      temp = temp[keywords[i]] = {};
      i++;
    }
    if (swap) {
      for (i in temp) {
        if (swap[i] === void 0) {
          swap[i] = temp[i];
        }
      }
      temp = par[keywords[len - 1]] = swap;
    }
    return temp;
  };
  read['orderLog'] = function() {
    return sequence;
  };
})(this, document, {}, [], (function(required) {
  throw Error('not found ' + required);
}));
