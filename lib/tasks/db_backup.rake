require "open3"
require "zlib"

namespace :db do
  desc "DB をダンプして S3 (ENV BACKUP_BUCKET) に保存する。scheduler が毎日実行する"
  task backup: :environment do
    bucket = ENV["BACKUP_BUCKET"].presence
    abort "BACKUP_BUCKET が未設定のためスキップ" unless bucket

    cfg = ActiveRecord::Base.connection_db_config.configuration_hash
    key = "db/#{cfg[:database]}-#{Time.current.strftime('%Y%m%d-%H%M%S')}.sql.gz"
    dump = ["mysqldump", "--single-transaction", "--no-tablespaces", "--routines",
            "-h", cfg[:host].to_s, "-u", cfg[:username].to_s, cfg[:database].to_s]

    Tempfile.create(["backup", ".sql.gz"], binmode: true) do |file|
      gz = Zlib::GzipWriter.new(file)
      Open3.popen3({ "MYSQL_PWD" => cfg[:password].to_s }, *dump) do |_stdin, stdout, stderr, wait|
        IO.copy_stream(stdout, gz)
        raise "mysqldump failed: #{stderr.read}" unless wait.value.success?
      end
      gz.finish
      file.rewind

      require "aws-sdk-s3"
      Aws::S3::Client.new.put_object(bucket: bucket, key: key, body: file)
      puts "backup uploaded: s3://#{bucket}/#{key} (#{file.size} bytes)"
    end
  end
end
