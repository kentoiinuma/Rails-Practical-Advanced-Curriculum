namespace :articles do
    desc 'Update status of articles from publish_wait to published if their published_at has passed'
    task publish_waiting_articles: :environment do
      Article.where(state: 'publish_wait').find_each do |article|
        if article.published_at <= Time.current
          article.update!(state: 'published')
        end
      end
    end
  end
  