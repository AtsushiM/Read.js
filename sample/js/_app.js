read.ns('ns.Test2', function() {
    document.write('exe: test2.<br/ >');
});

read.ns('ns.Test3', function() {
    document.write('exe: test3.<br/ >');
});

var Test2 = read('ns.Test2', 'js/_src/Test2');
read('ns.Test3', 'js/_src/Test3');


read.ns('ns.Test1', function() {
    document.write('exe: test1.<br/ >');

    new Test2;
    new ns.Test3;
});

read.ns('ns');

var Test1 = read('ns.Test1', 'js/_src/Test1');
var test2 = read('ns.Test2', 'js/_src/Test2');

new Test1();
