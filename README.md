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
非同期でファイルの読み込みと実行を行うため、runメソッドを使わなかった場合に比べてデバッグしやすいというメリットがあります。

```html
// js/main.jsからread(keyword, path)を検索しファイル読み込みを行う
<script type="text/javascript">
    read.run('js/main'); // .jsは省略可能
</script>
```

## Compile
compiler/unite.rbを使用してjsファイルを結合することが可能です。

```command
ruby unite.rb --root=path/to/dir --main=path/to/dir/file.js --output=path/to/file.js --remove_read_path=1 --remove_read_path=1 --copyright_output=path/to/copy.js

ruby unite.rb -r path/to/dir -m path/to/dir/file.js -o path/to/file.js -p 1 -a 1 -c path/to/copy.js
```

--outputと--remove_read_path,--remove_read_all,--copyright_outputは省略可能です。<br />
--remove_read_pathに1を指定した場合、read(keyword, path)をread(keyword)に置換します。<br />
--remove_read_allに1を指定した場合、read.jsのメソッドをすべてjavascriptネイティブに書き換えて出力します。<br />
--copyright_outputは指定されたファイルに/**/で囲まれたcopyrightを思われるコメントを抜き出して出力します。<br />
出力されるコメントは/*!で始まるコメントか、copyright,もしくは(c)を含むコメントが対象です。
