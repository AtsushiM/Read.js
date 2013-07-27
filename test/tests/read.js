describe('readは', function() {
    it('read(readtxt)でwindow以下からreaddtxtでの指定が存在するかチェックし、その値を返す', function(done) {
        expect(read('read')).to.be.a('function');
        try {
            read('read.TestClass');
        }
        catch (e) {
            done();
        }
    });

    it('read(readtxt, srcpath)で同期的にファイルを読み込み展開する', function(done) {
        expect(read('read.TestClass', 'common/TestClass')).to.be.a('function');
        expect(read('read.TestClass2', 'common/TestClass2')).to.be.a('function');

        try {
            read('read.TestClass1', 'common/TestClass');
        }
        catch (e) {
            done();
        }
    });

    it('read.orderLog()でreadメソッドで読込された順番にファイル名をconsole.logに表示し、配列を返す', function() {
        var order = read.orderLog();

        expect(order).to.be.a('array');
        expect(order).to.be.eql([
            'common/TestClass.js',
            'common/TestClass2.js'
        ]);
    });
});
