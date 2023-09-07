class Admin::Articles::PreviewsController < ApplicationController
  skip_before_action :require_login

  before_action :preview!

  def show
    @article = Article.find_by!(uuid: params[:article_uuid])
    @article.body = @article.build_body(self)

    eyecatch_alignment_mapping = {
      '左寄せ' => 'text-left',
      '中央' => 'text-center',
      '右寄せ' => 'text-right'
    }

    @eyecatch_alignment_class = eyecatch_alignment_mapping[@article.eyecatch_alignment]
  end
end
