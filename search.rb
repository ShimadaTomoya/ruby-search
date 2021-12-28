require './model/token'
require 'sqlite3'

args = Hash.new(nil)
i = 0
(ARGV.size-1).times do
  args[ARGV[i]] = ARGV[i+1]
end
db_name = args['--database'] || 'search-resources.db'
query = args['--query'] || ''

db = SQLite3::Database.new db_name
# 検索
postings = []
Token.ngram_tokens(query).each do |token|
  rows = db.execute("select postings from tokens where token = ?;", token)
  postings += rows.flatten[0].split(',') if (rows != [])
end

p postings.tally
# p postings.tally.sort{|a,b| b[1] <=> a[1]}[0][0]
