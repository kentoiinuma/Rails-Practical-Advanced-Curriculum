class ArticleBlock < ApplicationRecord
  belongs_to :article
  belongs_to :blockable, polymorphic: true, dependent: :destroy

  with_options on: %i[create update] do
    validates :blockable_type, presence: true
    validates :blockable_id, presence: true
    validates :level, presence: true, uniqueness: { scope: :article_id }
  end

  with_options on: :insert do
    validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end

  class << self
    def blockable_types
      %w[Sentence Medium Embed]
    end

    def valid_blockable_type?(type)
      blockable_types.include?(type.to_s.classify)
    end
  end

  def sentence?
    blockable.is_a?(Sentence)
  end

  def medium?
    blockable.is_a?(Medium)
  end

  def embed?
    blockable.is_a?(Embed)
  end

  def insert_and_save!
    # levelをずらす
    article_blocks = article.article_blocks.where('level >= ?', level).reorder(level: :desc)
    article_blocks.each do |article_block|
      article_block.level += 1
      article_block.save!
    end
    save!
  end

  def create_blockable!(type, identifier = nil)
    case type.to_s.classify
    when 'Sentence'
      self.blockable = Sentence.create!
    when 'Medium'
      self.blockable = Medium.create!
    when 'Embed'
      self.blockable = Embed.create!(identifier: identifier) # この行を修正
    else
      raise "ブロックタイプが不正です (#{type})"
    end

    blockable
  end
end
