module.exports = function(grunt)
{
    grunt.task.registerMultiTask('unite-read-js', 'Read.js Compile', function()
    {
        var result = '',
            data = this.data,
            target = data.target,
            startjs = data.startjs,
            basedir = data.basedir,
            reg_readmethod = /(\n|=)\s*read\(.+?,\s*['"](.+?)['"]\)[,;]/,
            path = [],
            loaded_path = {};

        if (basedir[basedir.length - 1] !== '/') {
            basedir += '/';
        }

        checkReadLoop(startjs);
        path.push(startjs);

        /* console.log(path); */

        grunt.file.write(
            target,
            catJSFilesValue(path)
        );

        function catJSFilesValue(path) {
            var i = 0,
                len = path.length,
                ret = '';

            for (; i < len; i++) {
                ret += grunt.file.read(path[i]) + '\n';
            }

            return ret;
        }

        function checkReadLoop(jspath) {
            var filevalue = grunt.file.read(jspath),
                result,
                temp;

            while (result = filevalue.match(reg_readmethod)) {
                temp = makePath(result[2]);

                if (!loaded_path[temp]) {
                    loaded_path[temp] = true;
                    checkReadLoop(temp);

                    path.push(temp);
                }

                filevalue = filevalue.slice(result.index + result[0].length);
            }
        }

        function makePath(path) {
            if (path[0] === '/') {
                path = path.slice(1);
            }

            return basedir + path + '.js';
        }
    });
};
