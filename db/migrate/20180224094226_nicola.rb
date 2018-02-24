class Nicola < ActiveRecord::Migration[5.1]
  def change
    create_table :nicola do |t|
      t.string :name, null: false, default: ""
    end
  end
end
