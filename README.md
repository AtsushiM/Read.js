# Read.js
jsファイルを同期的に読み込むミニマムなライブラリです。
最終的に結合されることが前提のjs開発において威力を発揮します。


[![Build Status](https://travis-ci.org/AtsushiM/Read.js.png?branch=master)](https://travis-ci.org/AtsushiM/Read.js)


## Usage
```javascript
// 対象がwindow以下に存在するかチェック
var TestClass = read('hogehoge.TestClass');

// 対象ファイルを読み込み(js拡張子は省略する)
read('hogehoge.TestClass', 'path/to/file');

```

## More
結合用のファイルを提供するツールを作成中です。
