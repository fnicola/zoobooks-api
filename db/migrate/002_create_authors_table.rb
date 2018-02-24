class CreateAuthorsTable < ActiveRecord::Migration[5.0]
	def change
		create_table :authors do |t|
			t.string :name
			t.string :nationality
		end
	end
end