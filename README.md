# Rails チュートリアル 学習リポジトリ

Michael Hartl『Ruby on Rails チュートリアル』（**第7版** / Rails 7.0・Ruby 3.1）を
Docker 環境で進めながら、毎日コツコツ習慣化していくための学習用リポジトリ。

## 参照先（教材）

- **Ruby on Rails チュートリアル（日本語版）**: https://railstutorial.jp/
- 使用している版: **第7版**（Rails 7.0 / Ruby 3.1 系）
- 原著（英語版）: https://www.railstutorial.org/

## このリポジトリの使い方

| ファイル                            | 役割                                                           |
| ----------------------------------- | -------------------------------------------------------------- |
| [`TODO.md`](./TODO.md)              | 全14章のチェックリスト。「今日どこをやるか」をここで決める。   |
| `docker-compose.yml` / `Dockerfile` | 開発環境（準備中）。Ruby/Rails/PostgreSQL はすべてコンテナ内。 |

進捗ログは別ファイルを作らず **git のコミット履歴**で管理する。

## 想定ファイル構成

`rails new` + Docker セットアップ完了後は、おおよそ以下の構成になる想定。
（★ = この学習リポジトリ用に手で用意するファイル / それ以外は Rails が生成）

```
rails_practice_20260529/
├── README.md           ★ … このファイル（学習方針・環境メモ）
├── TODO.md             ★ … 全14章の進捗チェックリスト
│
├── Dockerfile          ★ … web コンテナの定義（Ruby 3.1.2 ベース）
├── docker-compose.yml  ★ … web + db の2コンテナ構成
├── entrypoint.sh       ★ … server.pid 削除などの起動前処理
├── .dockerignore       ★ … イメージに含めない不要ファイル
│
├── Gemfile / Gemfile.lock … 依存 gem（rails new が上書き生成）
├── config/
│   ├── database.yml        … DB接続設定（db コンテナを向くよう手で調整）
│   ├── routes.rb           … ルーティング
│   └── ...
├── app/                    … アプリ本体（MVC）
│   ├── models/             … モデル（User, Micropost ...）
│   ├── views/              … ビュー（erb テンプレート）
│   ├── controllers/        … コントローラ
│   └── ...
├── db/
│   ├── migrate/            … マイグレーション（章を進めると増える）
│   └── seeds.rb            … サンプルデータ生成
├── test/                   … テスト（チュートリアルはテスト駆動で進む）
└── public/                 … 静的ファイル
```

> 章を進めるごとに `app/` `db/migrate/` `test/` の中身が増えていく。
> 「今どのファイルをいじっているか」が構造のどこに当たるかを意識すると理解が早い。

## 学習のルーティン

1. `docker compose up` で環境を起動
2. チュートリアルを進める（`TODO.md` の該当節を意識）
3. 終わりに `TODO.md` のチェックを更新
4. 節/章の区切りで `git commit`（詰まった点・気づきはコミットメッセージに残す等）

## 環境メモ（Docker）

- Ruby・Rails・gem・PostgreSQL はすべて **コンテナの中**。Mac には Docker Desktop だけ。
- バージョン: Ruby **3.1.2** / Rails **7.0.4** / PostgreSQL（`Dockerfile`・`docker-compose.yml` で固定）。
- 構成: `web`（Rails）+ `db`（PostgreSQL）の2コンテナ。
- ソースコードは Mac 側に置き、コンテナにマウントして動かす（編集はMacのエディタ、実行はコンテナ）。

### チュートリアルコマンドの Docker 読み替え

チュートリアルは「Macに直接コマンドを打つ」前提。Docker では `web` コンテナ越しに実行する。

| チュートリアルの記載 | Docker での実行                                           |
| -------------------- | --------------------------------------------------------- |
| `rails server`       | `docker compose up`                                       |
| `rails generate ...` | `docker compose run --rm web rails generate ...`          |
| `rails db:migrate`   | `docker compose run --rm web rails db:migrate`            |
| `rails console`      | `docker compose run --rm web rails console`               |
| `bundle install`     | `docker compose run --rm web bundle install`（or 再ビルド） |
| `rails test`         | `docker compose run --rm web rails test`                  |

> 💡 よく使うのでエイリアス推奨: `alias dc='docker compose'` / `alias dcr='docker compose run --rm web'`

環境の具体的な定義は [`Dockerfile`](./Dockerfile) と [`docker-compose.yml`](./docker-compose.yml) を直接参照。

### DB まわりの注意（第7版との差分）

第7版は開発DBに **SQLite**、本番のみ PostgreSQL という構成。
このリポジトリは**開発も本番も PostgreSQL に統一**しているため、
チュートリアルの `Gemfile`（`sqlite3`）や `config/database.yml` の記述とは異なる。
→ DB 設定は**このリポジトリの `database.yml` / `Gemfile`（pg）に従う**こと。
チュートリアルの SQLite 向け記述はスキップして OK。
