class Embed < ApplicationRecord
  has_one :article_block, as: :blockable, dependent: :destroy
  has_one :article, through: :article_block

  enum embed_type: { youtube: 0, twitter: 1 }

  validates :identifier, length: { maximum: 200 }, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL', allow_blank: true }

  def split_id_from_youtube_url
    # YoutubeならIDのみ抽出
    identifier.split('/').last if youtube?
  end
end
