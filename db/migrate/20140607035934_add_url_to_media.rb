class AddUrlToMedia < ActiveRecord::Migration
  def change
  	add_column :media, :asset_url, :string
  end
end
