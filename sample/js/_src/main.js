read.ns('ns');

var Test1 = read('ns.Test1', 'js/_src/Test1');
var test2 = read('ns.Test2', 'js/_src/Test2');
var $ = read('$', 'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js');

new Test1();
