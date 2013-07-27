# Read.js
jsファイルを同期的に読み込むミニマムなライブラリです。<br />
最終的に結合されることが前提のjs開発において威力を発揮します。<br />
また、gruntを使用して、Read.jsを使用したプロジェクトのjsファイルを結合することもできます。<br />

[https://github.com/AtsushiM/unite-read-js](https://github.com/AtsushiM/unite-read-js)<br />


[![Build Status](https://travis-ci.org/AtsushiM/Read.js.png?branch=master)](https://travis-ci.org/AtsushiM/Read.js)<br />

## Usage
```javascript
// 対象がwindow以下に存在するかチェック
var TestClass = read('hogehoge.TestClass');

// 対象ファイルを読み込み(js拡張子は省略する)
read('hogehoge.TestClass', 'path/to/file');


///////////////////////////////////////////////////////

// 同期読み込みのため、以下の様にネストせずに記述可能
var Action = read('fugafuga.Action', 'path/to/file'),
    action = new Action();

action.method();

///////////////////////////////////////////////////////
```

### read.ns(keyword, swap)
名前空間をkeywordを元に作成します。<br />
swapが指定された場合、作成される名前空間に使用されます。<br />
keywordに指定した場所になんらか値が存在していた場合、swapと置き換えられ、<br />
元の値が持っていたプロパティをswapに追加します。<br />
swapと元の値が同じプロパティを持っていた場合、swapのプロパティが優先されます。

```javascript
// widnow.namespace.storeにオブジェクトを作成
read.ns('namespace.store');

// widnow.namespace.Testに関数を設定
read.ns('namespace.Test', function() {
    // write code.
});

```

### read.orderLog()
jsファイルのパスを読み込んだ順の配列で返すメソッドです。

```javascript
// 連続して読み込み
read('hogehoge.TestClass1', 'path/to/file1');
read('hogehoge.TestClass2', 'path/to/file2');
read('hogehoge.TestClass3', 'path/to/file3');

// 読み込み済みのため無視
read('hogehoge.TestClass1', 'path/to/file1');

var order = read.orderLog();

/*
    order == [
        'path/to/file1.js',
        'path/to/file2.js',
        'path/to/file3.js'
    ]
 */

```
