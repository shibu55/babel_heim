## トップページ
https://babelheim.com/
## サインイン画面
https://babelheim.com/admins/sign_in
<br>
email: ****
<br>
password: ****
<br>
サインインした後はトップページが管理者仕様となります。ナビゲーションメニューのログアウトボタンからログアウトができます。
## Calendar
休日追加から遷移するページ（https://babelheim.com/holidays/new） でスタートタイムに日付を入れていただければお店の定休日を設定可能です。
<br>
一般のユーザーからは当月の休日情報しか見れません。
## Attending
管理者としてログインしている状態の時のみアイコンをクリックするとアイコンの使用状況を切り替えできます。
<br>
閉業時間になると自動で座席は全てクローズとなります。
<br>
開店時には開始ボタンをクリックすると全ての座席情報がオープン状態になります。
<br>
休業日には座席情報は表示されません。

## 開発・運用メモ

### ローカルで動かす
```
cp .env.example .env   # SECRET_KEY_BASE と DB_PASSWORD を埋める
docker compose up -d --build
open http://localhost:3000
```

### デプロイ
main に push（PR をマージ）すると GitHub Actions (`.github/workflows/deploy.yml`) が
イメージをビルドして ECR に push し、SSM 経由でサーバーの `/opt/babelheim` で `bin/server-deploy` を実行する。
サーバーの `.env` は SSM Parameter Store (`/babelheim/*`) から毎回生成される。

### 定期実行
`config/crontab` に書く（compose の `scheduler` サービスが実行する、時刻は JST）。
- 毎日 23:00 全座席を空席に戻す
- 毎日 4:30 DB を S3 にバックアップ（30 日保持）

### インフラ
EC2・ECR・S3・IAM などは [shibu55_terraform](https://github.com/shibu55/shibu55_terraform) の `main/babelheim.tf` で管理している。
