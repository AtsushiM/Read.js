# Read.js
jsファイルを同期的に読み込むミニマムなライブラリです。<br />
最終的に結合されることが前提のjs開発において威力を発揮します。<br />
また、compiler/unite.rbやgruntタスクを使用して、Read.jsを使用したプロジェクトのjsファイルを結合することもできます。<br />

[https://github.com/AtsushiM/unite-read-js](https://github.com/AtsushiM/unite-read-js)<br />


[![Build Status](https://travis-ci.org/AtsushiM/Read.js.png?branch=master)](https://travis-ci.org/AtsushiM/Read.js)<br />

## Usage

### read(keyword, [path])
keywordに値が存在する場合はその値を返します。<br />
keywordに値が存在せず、かつpathが指定された場合、pathのjsファイルを同期的に読み込み、<br />
再度keywordでチェックを行います。<br />
pathは必ずStringリテラルで指定してください。

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

### read.ns(keyword, [swap])
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

### read.run(path)
pathから使用するjsファイルを解析し、ファイルの読み込みを行います。<br />
このメソッドを使った場合、script要素のsrc属性を使用してファイル読み込みを行うため、<br />
使わなかった場合に比べてデバッグしやすいというメリットがあります。

```html
// js/main.jsからread(keyword, path)を検索しファイル読み込みを行う
<script type="text/javascript">
    read.run('js/main'); // .jsは省略する
</script>
```

## Compile
compiler/unite.rbを使用してjsファイルを結合することが可能です。

```command
ruby unite.rb --root=path/to/dir --main=path/to/dir/file.js --output=path/to/file.js --remove_read_path=1

ruby unite.rb -r path/to/dir -m path/to/dir/file.js -o path/to/file.js -p 1
```

--outputと--remove_read_pathは省略可能です。<br />
--remove_read_pathに1を指定した場合、read(keyword, path)をread(keyword)に置換します。
