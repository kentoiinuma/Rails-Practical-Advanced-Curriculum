class SearchArticlesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category_id, :integer
  attribute :title, :string
  attribute :author_id, :integer
  attribute :tag_id, :integer # 単数形に変更
  attribute :body, :string

  def search
    relation = Article.distinct.includes(:author, :tags)

    relation = relation.by_category(category_id) if category_id.present?
    title_words.each do |word|
      relation = relation.title_contain(word)
    end
    relation = relation.where(author_id: author_id) if author_id.present?

    if tag_id.present?
      relation = relation.joins(:article_tags).where(article_tags: { tag_id: tag_id }).distinct
    end

    if body.present?
      relation = relation.joins(:sentences).where('sentences.body LIKE ?', "%#{body}%").distinct
    end

    relation
  end

  private

  def title_words
    title.present? ? title.split(nil) : []
  end
end
