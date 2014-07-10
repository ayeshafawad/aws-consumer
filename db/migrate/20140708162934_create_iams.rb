class CreateIams < ActiveRecord::Migration
  def change
    create_table :iams do |t|
      t.string :name

      t.timestamps
    end
  end
end
