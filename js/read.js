// Generated by CoffeeScript 1.6.3
(function(win, doc, required_obj, reg_readmethod, errorNotFound) {
  var presenceCheck, read, xhrGet, xhrSyncScriptLoad;
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
  xhrGet = function(srcpath) {
    var res, xhr;
    res = '';
    xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          res = xhr.responseText;
        } else {
          errorNotFound(srcpath);
        }
      }
    };
    xhr.open('GET', srcpath + '?t=' + new Date * 1, false);
    xhr.send();
    return '\n' + res.replace(/\r\n?/g, '\n');
  };
  xhrSyncScriptLoad = function(srcpath) {
    var res;
    res = xhrGet(srcpath);
    doc.head.appendChild(doc.createElement('script')).text = '//src:' + srcpath + res;
  };
  (read = win['read'] = function(required, srcpath) {
    var cls;
    cls = presenceCheck(required);
    if (!cls) {
      if (srcpath && !required_obj[srcpath]) {
        required_obj[srcpath] = true;
        srcpath += '.js';
        xhrSyncScriptLoad(srcpath);
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
  read['run'] = function(path, callback) {
    var checkReadLoop, loadLoop, require_ary;
    path = path + '.js';
    require_ary = [];
    checkReadLoop = function(jspath) {
      var filevalue, result, temp;
      filevalue = xhrGet(jspath);
      while (result = filevalue.match(reg_readmethod)) {
        temp = result[2] + '.js';
        if (!required_obj[temp]) {
          required_obj[temp] = true;
          checkReadLoop(temp);
          require_ary.push(temp);
        }
        filevalue = filevalue.slice(result.index + result[0].length);
      }
    };
    checkReadLoop(path);
    required_obj[path] = true;
    require_ary.push(path);
    loadLoop = function() {
      var loadaction, script, src;
      if (src = require_ary.shift()) {
        script = doc.createElement('script');
        loadaction = function() {
          script.removeEventListener('load', loadaction);
          return loadLoop();
        };
        script.addEventListener('load', loadaction);
        script.src = src;
        doc.head.appendChild(script);
      } else {
        if (callback) {
          callback();
        }
      }
    };
    loadLoop();
  };
})(window, document, {}, /(\n|=|,|;|:|\(|&|\|)\s*read\(.+?,\s*['"](.+?)['"]\)/, (function(required) {
  throw Error('not found ' + required);
}));
