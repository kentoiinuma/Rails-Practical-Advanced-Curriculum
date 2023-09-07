class AddEyecatchDetailsToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eyecatch_width, :integer
    add_column :articles, :eyecatch_alignment, :string
  end
end
