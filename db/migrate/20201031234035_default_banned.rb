class DefaultBanned < ActiveRecord::Migration[6.0]
  def change
	change_table :users do |t|
	  t.remove :banned
	  t.boolean :banned, default: 0
	end
  end
end
