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

        try {
            read('read.TestClass1', 'common/TestClass');
        }
        catch (e) {
            delete TestClass;
            done();
        }
    });

    // it('read(readtxt, srcpath, callback)で非同期にファイルを読み込み展開する', function(done) {
    //     var ret = read('read.TestClass2', 'common/TestClass2.js', function() {
    //         expect(read.TestClass2).to.be.a('function');
    //         delete read.TestClass2;
    //         done();
    //     });

    //     expect(ret).to.eql(undefined);
    // });
});
