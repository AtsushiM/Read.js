(function(win, doc, required_obj, reg_readmethod, time, read) {
  read = win['read'] = function(required, srcpath, cls) {
    /* var cls; */
    if (!(cls = checkPersence(required))) {
      if (srcpath && !required_obj[srcpath]) {
        required_obj[srcpath += '.js'] = true;
        xhrSyncScriptLoad(srcpath);
      } else {
        errorNotFound(required);
      }
    }
    if (!(cls = checkPersence(required))) {
      errorNotFound(required);
    }
    return cls;
  };
  read['ns'] = function(keywords, swap, i) {
    keywords = keywords.split('.');

    var i = 0, len = keywords.length, par, temp = win;

    while (i < len) {
      par = temp;
      if (temp[keywords[i]]) {
        temp = temp[keywords[i]];
      }
      else {
        temp = temp[keywords[i]] = {};
      }
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
  read['run'] = function(path) {
    var loaded_paths = {},
        require_ary = [],
        unitefile = '';

    path = path + '.js';

    checkReadLoop(path);

    function checkReadLoop(jspath) {
      require_ary.unshift(jspath);
      if (!required_obj[jspath]) {
        required_obj[jspath] = 1;
        getFile(jspath, function(filevalue, result, temp) {
          /* var result, temp; */
          unitefile = filevalue + unitefile;
          if (result = unitefile.match(reg_readmethod)) {
            temp = result[1] + '.js';
            unitefile = unitefile.slice(result.index + result[0].length);
            require_ary.unshift(temp);
            return checkReadLoop(temp);
          }
          loadLoop();
        });
      }
    }
    function loadLoop() {
      var script, src, ev = 'load';

      if (src = require_ary.shift()) {
        if (!loaded_paths[src]) {
          loaded_paths[src] = 1;
          script = doc.createElement('script');
          script.addEventListener(ev, loadaction);
          script.src = srcpathNoCache(src);
          doc.head.appendChild(script);
        } else {
          loadLoop();
        }
      }

      function loadaction() {
        script.removeEventListener(ev, loadaction);
        loadLoop();
      }
    }
  };

  function srcpathNoCache(srcpath) {
    return srcpath + '?' + time;
  }
  function checkPersence(required) {
    var i, temp = win;

    required = required.split('.');

    for (i in required) {
      temp = temp[required[i]];
      if (!temp) {
        break;
      }
    }
    return temp;
  }
  function getFile(srcpath, callback) {
    var res, xhr = new XMLHttpRequest;

    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        if (xhr.status == 200) {
          res = '\n' + xhr.responseText;
        } else {
          errorNotFound(srcpath);
        }
        if (callback) {
          callback(res);
        }
      }
    };
    xhr.open('GET', srcpathNoCache(srcpath), !!callback);
    xhr.send();
    return res;
  }
  function xhrSyncScriptLoad(srcpath) {
    doc.head.appendChild(doc.createElement('script')).text = '//src:' + srcpath + getFile(srcpath);
  }
  function errorNotFound(required) {
    throw Error('not found ' + required);
  }
})(window, document, {}, /[=,;:&\n\(\|]\s*read\(.+?,\s*['"](.+?)['"]\)/, +(new Date));
