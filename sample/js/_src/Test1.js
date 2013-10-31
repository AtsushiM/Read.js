/* 
 * copyright mizoue
 * sample Test Class.
 *
 */
var Test2 = read('ns.Test2', 'js/_src/Test2');
read('ns.Test3', 'js/_src/Test3');


read.ns('ns.Test1', function() {
    document.write('exe: test1.<br/ >');

    new Test2;
    // --remove_read_allオプションを使用する場合、エラーになる
    /* new ns.Test3; */

    var Test3 = read('ns.Test3');
    new Test3;
});
