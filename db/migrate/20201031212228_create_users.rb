class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.uuid :guild_id
	  t.boolean :banned
	  t.integer :status, default: 0
	  t.boolean :admin, default: false

      t.timestamps
    end
  end
end
