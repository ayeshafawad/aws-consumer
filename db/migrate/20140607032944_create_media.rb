class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :name
      t.string :description
      t.string :asset_file_name
      t.string :asset_content_type
      t.string :asset_file_size

      t.timestamps
    end
  end
end
