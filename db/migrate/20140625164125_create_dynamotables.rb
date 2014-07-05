class CreateDynamotables < ActiveRecord::Migration
  def change
    create_table :dynamotables do |t|
      t.string :name

      t.timestamps
    end
  end
end
