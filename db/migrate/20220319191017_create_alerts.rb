class CreateAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      t.float :target_price,              null: false, default: 0
      t.integer :status,                    null: false, default: 0
      t.references :user
      t.references :coin

      t.timestamps
    end
  end
end
