set :output, "log/cron.log" # ログの出力先

# 1時間ごとに実行
every 1.hour do
  # ステータスが「公開待ち」で、公開日時が過去になっている記事のステータスを「公開」に更新するRakeタスク
  rake "articles:publish_waiting_articles"
end

every 1.day, at: '9:00 am' do
  runner "ArticleMailer.report_summary.deliver_now"
end
