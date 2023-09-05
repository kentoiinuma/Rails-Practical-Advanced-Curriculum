class Article < ApplicationRecord
  belongs_to :category
  belongs_to :author

  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_blocks, -> { order(:level) }, inverse_of: :article
  has_many :sentences, through: :article_blocks, source: :blockable, source_type: 'Sentence'
  has_many :media, through: :article_blocks, source: :blockable, source_type: 'Medium'
  has_many :embeds, through: :article_blocks, source: :blockable, source_type: 'Embed'

  has_one_attached :eye_catch

  enum state: { draft: 0, published: 1, publish_wait: 2 }

  validates :slug, slug_format: true, uniqueness: true, length: { maximum: 255 }, allow_blank: true
  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :state, presence: true
  validates :eye_catch, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 10_485_760 }

  with_options if: :published? do
    validates :slug, slug_format: true, presence: true, length: { maximum: 255 }
    validates :published_at, presence: true
    validates :category_id, presence: true
  end

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :slug, to: :category, prefix: true, allow_nil: true
  delegate :name, to: :author, prefix: true, allow_nil: true

  before_create -> { self.uuid = SecureRandom.uuid }

  scope :viewable, -> { published.where('published_at < ?', Time.current) }
  scope :new_arrivals, -> { viewable.order(published_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_contain, ->(word) { where('title LIKE ?', "%#{word}%") }

  def build_body(controller)
    result = ''

    article_blocks.each do |article_block|
      block_content = if article_block.sentence?
                        sentence = article_block.blockable
                        sentence&.body # &. を使用してnilの場合はnilを返す
                      elsif article_block.medium?
                        medium = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                        controller.render_to_string("shared/_media_#{medium.media_type}", locals: { medium: medium }, layout: false)
                      elsif article_block.embed?
                        embed = ActiveDecorator::Decorator.instance.decorate(article_block.blockable)
                        controller.render_to_string("shared/_embed_#{embed.embed_type}", locals: { embed: embed }, layout: false)
                      end

      result << block_content.to_s # to_s を使用してnilの場合は空文字列に変換
    end

    result
  end

  def next_article
    @next_article ||= Article.viewable.order(published_at: :asc).find_by('published_at > ?', published_at)
  end

  def prev_article
    @prev_article ||= Article.viewable.order(published_at: :desc).find_by('published_at < ?', published_at)
  end
end
