# 検索エンジン一筆書き

## 使い方
```bash
bundle install
bundle exec ruby create_index.rb --database search-resources.db --source-text ./sample/source.txt
bundle exec ruby search.rb --query 織田信長
```

## くわしい使い方