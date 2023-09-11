class AddTwitterToEmbedType < ActiveRecord::Migration[5.2]
  def change
    change_column :embeds, :embed_type, :integer, default: 0, null: false, limit: 2
  end
end
