module.exports = function(grunt) {
    grunt.initConfig({
        //Unite Read.js
        'unite-read-js': {
            dest: {
                basedir: './htdocs', // 基準となるhtmlが置かれているディレクトリ
                startjs: './htdocs/js/_src/main.js', // 基準となるjsへのパス
                target: './htdocs/js/app.js' // 書き出されるjsへのパス
            }
        },
        watch: {
            js : {
                files : './htdocs/js/**/*.js',
                tasks : ['unite-read-js']
            }
        }
    });

    grunt.loadTasks('tasks');

    grunt.registerTask('default', ['unite-read-js']);
};
