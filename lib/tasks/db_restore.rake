require "open3"
require "zlib"

namespace :db do
  desc "S3 (ENV BACKUP_BUCKET) にあるバックアップの一覧（新しい順に 20 件）"
  task backups: :environment do
    require "aws-sdk-s3"
    bucket = ENV.fetch("BACKUP_BUCKET")
    objects = Aws::S3::Client.new.list_objects_v2(bucket: bucket, prefix: "db/").contents
    objects.sort_by(&:last_modified).reverse.first(20).each do |o|
      puts "#{o.last_modified.localtime.strftime('%Y-%m-%d %H:%M')}  #{o.size.to_s.rjust(8)}  #{o.key}"
    end
  end

  desc "S3 のバックアップを DB に取り込む（既存データは上書き）。例: bin/rails db:restore KEY=db/xxx.sql.gz CONFIRM=yes"
  task restore: :environment do
    require "aws-sdk-s3"
    bucket = ENV.fetch("BACKUP_BUCKET")
    key = ENV["KEY"].presence or abort "KEY=db/... を指定してください（一覧は bin/rails db:backups）"
    cfg = ActiveRecord::Base.connection_db_config.configuration_hash
    abort "#{cfg[:database]} を s3://#{bucket}/#{key} で上書きします。よければ CONFIRM=yes を付けて再実行してください" unless ENV["CONFIRM"] == "yes"

    Tempfile.create("restore") do |file|
      Aws::S3::Client.new.get_object(bucket: bucket, key: key, response_target: file.path)
      sql = key.end_with?(".gz") ? Zlib::GzipReader.open(file.path) : File.open(file.path, "rb")

      cmd = ["mysql", "--default-character-set=utf8mb4", "-h", cfg[:host].to_s, "-u", cfg[:username].to_s, cfg[:database].to_s]
      Open3.popen3({ "MYSQL_PWD" => cfg[:password].to_s }, *cmd) do |stdin, _stdout, stderr, wait|
        stdin.binmode
        IO.copy_stream(sql, stdin)
        stdin.close
        raise "mysql failed: #{stderr.read}" unless wait.value.success?
      end
      sql.close
    end

    ActiveRecord::Base.connection.reconnect!
    counts = %w[admins holidays news seats shifts staffs shop_configs].to_h do |t|
      [t, ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{t}")]
    end
    puts "restored s3://#{bucket}/#{key}: #{counts}"
  end
end
