// Generated by CoffeeScript 1.6.3
(function() {
  var doc, errorNotFound, presenceCheck, read, required_obj, sequence, win;
  win = window;
  doc = document;
  required_obj = {};
  sequence = [];
  errorNotFound = function(required) {
    throw Error('not found ' + required);
  };
  presenceCheck = function(required) {
    var temp, val, _i, _len, _ref;
    temp = win;
    _ref = required.split('.');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      val = _ref[_i];
      temp = temp[val];
      if (!temp) {
        break;
      }
    }
    return temp;
  };
  read = function(required, srcpath) {
    var cls, xhr;
    cls = presenceCheck(required);
    if (!cls) {
      if (srcpath && !required_obj[srcpath]) {
        required_obj[srcpath] = true;
        srcpath += '.js';
        xhr = new XMLHttpRequest;
        xhr.onreadystatechange = function() {
          var script;
          if (xhr.readyState === 4) {
            if (xhr.status === 200) {
              doc.head.appendChild(script = doc.createElement('script'));
              script.text = '// src: ' + srcpath + '.js\n' + xhr.responseText;
              sequence.push(srcpath);
            } else {
              throw Error('file load error: ' + required);
            }
          }
        };
        xhr.open('GET', srcpath + '?t=' + (+(new Date)), false);
        xhr.send();
      } else {
        errorNotFound(required);
      }
    }
    if (!(cls = presenceCheck(required))) {
      errorNotFound(required);
    }
    return cls;
  };
  read['ns'] = function(keywords, swap) {
    var i, len, par, temp, val;
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
        val = temp[i];
        if (swap[i] === void 0) {
          swap[i] = val;
        }
      }
      par[keywords[len - 1]] = swap;
      temp = swap;
    }
    return temp;
  };
  read['orderLog'] = function() {
    var log, val, _i, _len;
    log = '';
    for (_i = 0, _len = sequence.length; _i < _len; _i++) {
      val = sequence[_i];
      log += val + ' ';
    }
    return sequence;
  };
  win['read'] = read;
})();
