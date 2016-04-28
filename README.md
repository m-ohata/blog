# 概要

[Markdown](https://ja.wikipedia.org/wiki/Markdown) からHTMLを生成します。
ブログの記事を高速に書くための、必要最小限の設定が入っているスケルトンプロジェクトです。

# 利用技術

- [Markdown](https://daringfireball.net/projects/markdown/)
- [Gulp](http://gulpjs.com/)
    - タスクランナー
    - Markdownファイルをhtmlファイルにコンパイルする為に利用
- [Node.js](https://nodejs.org/en/)
    - Gulpを動作させる為の環境
- [LiveScript](http://livescript.net/)
    - gulpfile.ls の記述に利用

# インストール方法

Node.js が既にインストールされている事が前提となります。
また Gulp コマンドが必要になるのでグローバルインストールする必要があります。

```Bash
$ git clone https://github.com/m-ohata/blog.git
$ cd blog
$ npm install -g gulp
$ npm install
```

# 使い方

`gulp --tasks`と入力すると、登録済のタスクが一覧表示されます。

```Bash
$ gulp --tasks
[17:51:37] Requiring external module livescript
[17:51:37] Using gulpfile ~/work/blog-skeleton/gulpfile.ls
[17:51:37] Tasks for ~/work/blog-skeleton/gulpfile.ls
[17:51:37] ├── default
[17:51:37] ├── markdown
[17:51:37] └── watch
```

## 登録済タスク一覧 (Gulp)

- markdown
    - postsディレクトリ配下の*.mdファイルをhtmlに変換しdistフォルダに出力
- watch
    - postsディレクトリ配下の*.mdファイルを監視し、変更があればmarkdownタスクを実行
    - 終了したい場合は Ctrl + C 等のコマンドで終了してください
- default
    - markdown -> watch の順にタスクを実行

`gulp [実行したいタスク名]` と入力することでタスクが実行されます。
何もタスク名を入力せず、単に`gulp`と入力して実行した場合、defaultタスクが実行されます。

```Bash
$ gulp markdown
[17:56:26] Requiring external module livescript
[17:56:26] Using gulpfile ~/work/blog-skeleton/gulpfile.ls
[17:56:26] Starting 'markdown'...
[17:56:26] gulp-debug: posts/test.md
[17:56:26] gulp-debug: 1 item
[17:56:26] Finished 'markdown' after 44 ms
```

## Markdown -> htmlの独自書式設定

導入先のブログによってはもっと別のタグに変換したいという要望があるかと思います。
今回 Markdown -> html の変換を行う為に利用している [gulp-markdown](https://www.npmjs.com/package/gulp-markdown) パッケージは
[marked](https://www.npmjs.com/package/marked) パッケージのラッパーとなっています。

[gulp-markdown](https://github.com/sindresorhus/gulp-markdown) のサイトでは下記のように記載しており、独自書式を定義したい場合、自由にカスタマイズできます。

> markdown.marked
> Access the marked object to customize the [lexer](https://github.com/chjj/marked#access-to-lexer-and-parser), [parser](https://github.com/chjj/marked#access-to-lexer-and-parser) or [renderer](https://github.com/chjj/marked#renderer).

gulpfile.lsの7行目でmarked.Rendererにアクセスし、
後続の流れで独自書式を当てはめています。
イメージを把握しやすいようにとJavaScriptで記載しました。

```JavaScript
var gulpMarkdown = require("gulp-markdown");
var renderer = new gulpMarkdown.marked.Renderer();
renderer.heading = function (text, level) {
  return "独自書式の文字列";
};
```

