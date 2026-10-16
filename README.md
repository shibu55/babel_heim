# Babel Heim

シーシャ店 Babel Heim のサイト https://babelheim.com/

営業時間・休日カレンダー・お知らせ・スタッフの出勤予定と、店内の座席の空き状況を表示する。管理者はサイト上でこれらを更新できる。

## 使い方（管理者）

[サインイン画面](https://babelheim.com/admins/sign_in) からログインすると、トップページが管理者用の表示になる。ログアウトはナビゲーションメニューから。

### 座席
- 座席のアイコンをクリックすると、使用中 / 空席を切り替えられる（管理者のみ）
- 毎日 23:00 に自動で全ての座席が空席（青）に戻る
- 開始ボタン（全席を空席にする）をクリックすると、いつでも全ての座席を空席に戻せる
- 休業日には座席情報は表示されない

### 休日カレンダー
- [休日追加](https://babelheim.com/holidays/new) で日付を入れると休日を設定できる
- 一般のユーザーには当月の休日だけが表示される

### その他
- 営業時間: [営業時間の編集](https://babelheim.com/edit_hour)
- お知らせ・スタッフ・シフトもトップページのリンクから追加・編集できる

## 構成

| | |
|---|---|
| アプリ | Ruby 3.4 / Rails 8.1（importmap, Propshaft）、Devise（管理者ログイン） |
| Web サーバー | Puma + Thruster（Let's Encrypt の証明書を自動で取得・更新し、443 で待ち受ける） |
| DB | MySQL 8.4 |
| 実行環境 | Docker Compose（`db` / `web` / `scheduler` の 3 サービス）を EC2 1 台で動かす |
| インフラ | [shibu55_terraform](https://github.com/shibu55/shibu55_terraform) の `babelheim/` で管理（EC2、DNS、ECR、S3、SSM、監視、デプロイ用の権限） |

| ファイル | 役割 |
|---|---|
| `compose.yaml` | ローカルと本番で共通の構成。差分は `.env` で切り替える |
| `compose.production.yaml` | 本番だけ重ねる設定（ログを CloudWatch Logs に送る） |
| `config/crontab` | 定期実行（`scheduler` サービスの supercronic が読む） |
| `bin/server-deploy` | 本番サーバーでデプロイ時に実行されるスクリプト |
| `.github/workflows/deploy.yml` | main へのマージで動くデプロイ |

## ローカルで動かす

```sh
cp .env.example .env   # SECRET_KEY_BASE と DB_PASSWORD を埋める
docker compose up -d --build
open http://localhost:3000
```

## デプロイ

main に PR をマージすると、GitHub Actions が次を行う。
1. イメージをビルドして ECR に push
2. タグ `DeployTarget=babelheim` の EC2 に SSM で `bin/server-deploy` を送る
3. サーバーで SSM Parameter Store (`/babelheim/*`) から `.env` を作り直し、新しいイメージでコンテナを入れ替え、`/up` が応答するまで待つ

コンテナの入れ替え中（数十秒）はサイトが 502 になるので、営業時間中のデプロイは避ける。

## 運用

### 定期実行（`config/crontab`、時刻は JST）
- 毎日 23:00 全座席を空席に戻す（`bin/rails seats_reset:open`）
- 毎日 4:30 DB を S3 にバックアップ（`bin/rails db:backup`、30 日保持）

### 監視
- `/up` は DB まで確認するヘルスチェック。Route 53 が監視していて、落ちるとメールが届く
- サーバーが応答しなくなったら自動で再起動・復旧する

### ログ
全コンテナのログは CloudWatch Logs のロググループ `babelheim`（30 日保持）に送られる。
```sh
aws logs tail babelheim --follow --profile shibu55
```

### サーバーに入る
SSH は閉じているので、SSM Session Manager を使う（session-manager-plugin が必要）。
```sh
aws ssm start-session --target <インスタンス ID> --profile shibu55
cd /opt/babelheim
docker compose ps
```

### バックアップから戻す
サーバーで:
```sh
cd /opt/babelheim
docker compose exec web bin/rails db:backups                                     # 一覧
docker compose exec -e KEY=db/xxx.sql.gz -e CONFIRM=yes web bin/rails db:restore # 上書きで復元
```
