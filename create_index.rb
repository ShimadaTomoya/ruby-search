require 'digest/md5'
require 'sqlite3'
#require './model/index'
require './model/token'

args = Hash.new(nil)
i = 0
(ARGV.size-1).times do
  args[ARGV[i]] = ARGV[i+1]
end

db_name = args['--database'] || 'search-resources.db'
source_text = args['--source-text'] || './sample/source.txt'

# データベース, テーブル準備
db = SQLite3::Database.new(db_name)
# Create a table
db.execute <<-SQL
  create table if not exists tokens (
    token text PRIMARY KEY,
    postings BLOB
  );
SQL

db.execute <<-SQL
  create table if not exists documents (
    id text PRIMARY KEY,
    body text NOT NULL
  );
SQL

# 文書をngramで分割して転置リストを作成する
inverted_indexes = Hash.new{|k,v| k[v] = Array.new}
open(source_text).each do |document|
  # documentのidはドキュメントbodyのハッシュ値とする
  document_id = Digest::MD5.hexdigest(document)
  db.execute("insert or ignore into documents values ( ?, ? );", document_id, document)
  Token.ngram_tokens(document).each do |token|
    inverted_indexes[token].push document_id
  end
end

# 転置リストをデータベースにぶち込む
inverted_indexes.each do |k,v|
  result = db.execute('select postings from tokens where token = ?;', k)
  if (result == [])
    db.execute("insert into tokens values ( ?, ? );", k, v.join(','))
  else
    postings = (result[0][0].split(',') | v).join(',')
    db.execute("update tokens set postings = ? where token = ?;", postings, k)
  end
end
