// Test1
var Test2 = read('ns.Test2', 'js/_src/Test2');
read('ns.Test3', 'js/_src/Test3');


read.ns('ns.Test1', function() {
    document.write('exe: test1.<br/ >');

    new Test2;
    new ns.Test3;
});
