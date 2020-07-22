# Anytime Nature
自然の写真だけの写真投稿サイトです。

作品URL: https://www.anytime-nature.xyz/

<img src="https://user-images.githubusercontent.com/63847712/88137883-7e1f6900-cc27-11ea-9829-c3217190994b.jpg" width=75% alt="トップページ">

## 制作背景
自然を見ることでリラックスしたり、ストレスが軽減する効果があると言われています。

私自身も、自然に触れることを目的に旅行に行くことが好きなのですが、日常生活の中でも自然を見る機会を増やしたいと感じ、このアプリを作ろうと考えました。

自然を見てリラックスすることがテーマなので、スライドショー表示機能などを取り入れ、写真を探すなどの煩雑な操作を極力無くすことを意識しました。

## 使用技術

### バックエンド
Ruby / Ruby on Rails
### フロントエンド
HTML / CSS / Haml / SCSS / JavaScript / jQuery
### 環境構築
#### 開発環境
Docker ( MySQL / Nginx / puma )
#### 本番環境
- MySQL / Nginx / Unicorn

- AWS ( EC2 / S3 / RDS / Route53 / ELB / ACM ) 

- CircleCIによるパイプライン構築 ( Rspec → Capistranoデプロイ )

## アプリケーションの機能一覧
- アカウント登録 / ログイン機能 ( devise )
- 管理ユーザー機能
- CRUD機能
- 画像アップロード機能 ( CarrierWave, AWS S3 )
- 投稿一覧のスライドショー表示機能 ( Slick )
- ページネーション機能 ( kaminari )
- 投稿の検索 / ソート機能 ( ransack )
- カテゴリー登録&検索機能 ( ancestry )
- タグ登録&検索機能 ( tag-it )
- パンくず機能 ( gretel )
- コメント機能
- お気に入り機能
- フォロー機能
- 通知機能
- 単体・機能・統合テスト ( Rspec )

## 使用イメージ
#### 投稿一覧 / お気に入り登録 / 詳細表示
<img src="https://user-images.githubusercontent.com/63847712/88139840-824d8580-cc2b-11ea-9eaf-a72a09245266.gif" width=600px alt="デモ1">

#### カテゴリー内の写真一覧をスライドショー表示
<img src="https://user-images.githubusercontent.com/63847712/88140403-a2317900-cc2c-11ea-9897-bb88faa18044.gif" width=600px alt="デモ2">

## 今後の開発予定
- お気に入りのフォルダ分け機能
- スライドショーの詳細設定機能
- レスポンシブ化
- 統合テストの充実

## インフラ構成図
<img src="https://user-images.githubusercontent.com/63847712/88137054-ad34db00-cc25-11ea-9f4b-681e4db2de09.png" width=75% alt="インフラ構成図">

## DB設計
<img src="https://user-images.githubusercontent.com/63847712/88134713-51b41e80-cc20-11ea-8877-8582c7a33ae3.png" width=75% alt="DB設計">
