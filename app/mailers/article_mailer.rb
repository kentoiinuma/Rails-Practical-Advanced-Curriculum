class ArticleMailer < ApplicationMailer
  def report_summary
    @total_articles = Article.where(state: 'published').count
    @yesterday_articles = Article.where(state: 'published', published_at: 1.day.ago.all_day)

    @yesterday_titles = if @yesterday_articles.count > 0
                          @yesterday_articles.pluck(:title).join(', ')
                        else
                          '昨日公開された記事はありません'
                        end

    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
  end
