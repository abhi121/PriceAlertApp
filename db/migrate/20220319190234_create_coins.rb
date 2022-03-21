class CreateCoins < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |t|

      t.string :name,                 null: false, default: ""
      t.string :symbol,               null: false, default: ""  
      t.float :current_price,       null: false


      t.timestamps
    end
  end

end
