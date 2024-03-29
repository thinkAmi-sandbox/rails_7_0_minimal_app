
# rails_7_0_minimal_app

## Create Environment

rails new.

```
% rails new rails_7_0_minimal_app --minimal --skip-bundle
```

setup `rbenv gemset` for RubyMine.

```
% rbenv gemset init
created rails_7_0_minimal_app for 3.1.2
created and initialized the following gemset for use with 3.1.2
=====
rails_7_0_minimal_app
=====
```

## Tested Environment

- Rails 7.0.4.2


## Related Blog (Written in Japanese)

- [Railsで、wrap_parametersで追加されたキーに対し、Strong Parametersのrequireやpermitを使ってみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2022/05/24/234536)
- [Rails7で導入された構文を使って、ActiveRecord::Enumを使ってみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2022/06/17/000042)
- [Railsにて、モデルのカスタムバリデーションメソッドの中で、標準のエラーメッセージを利用する - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/01/12/213848)
- [Railsで、DBから取得するデータに対し、order・sort_by・sortを使って、昇順・降順ソートする - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/02/19/222340)
- [Railsで、二重否定(!!) + ぼっち演算子(&.) が使われているソースコードの挙動を確認してみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/02/24/230107)
- [Rails + factory_botで、sub factoryやtrait・callbackを使って関連データを生成してみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/03/02/231008)
- [Rails + ActiveSupport::InheritableOptionsを使って、既存のハッシュをドットアクセスできるようにする - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/04/23/231402)
- [RSpec 3.12 + rspec-rails 6.0.2にて、change + have_attributesマッチャを使うとエラーになるため、回避策を試してみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/05/04/223930)
- [Rails + RSpecにて、changeマッチャまわりをいろいろ試してみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/05/05/233348)
- [ActiveSupportのdeep_mergeに対し、with_indifferent_accessと組み合わせたり、blockを渡してみたりしてみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/05/06/231813)
- [Rails + RSpecで、引数が必要なRake Taskのテストコードを書いてみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/06/08/003326)
- [Railsで、included付のConcernをincludeしたり、prepended付のConcernをprependしてみた - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/06/12/215910)
- [rspec-parameterizedで、letやlet!定義された変数の値を上書きする - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/10/04/201001)
- [rspec-parameterizedにて、factory_botのtraitを動的に指定する - メモ的な思考的な](https://thinkami.hatenablog.com/entry/2023/10/05/221931)