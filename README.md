# Read.js
jsファイルを同期的に読み込むミニマムなライブラリです。<br />
最終的に結合されることが前提のjs開発において威力を発揮します。


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

/**
  読み込んだjsファイルのパスを配列で返しconsoleに出力
 **/
// 連続して読み込み
read('hogehoge.TestClass1', 'path/to/file1');
read('hogehoge.TestClass2', 'path/to/file2');
read('hogehoge.TestClass3', 'path/to/file3');

// 読み込み済みのため無視
read('hogehoge.TestClass1', 'path/to/file1');

var order = read.orderLog();

/*
    console:
    hogehoge.TestClass1.js hogehoge.TestClass2.js hogehoge.TestClass3.js
 */
/*
    order == [
        'hogehoge.TestClass1.js',
        'hogehoge.TestClass2.js',
        'hogehoge.TestClass3.js'
    ]
 */

```
