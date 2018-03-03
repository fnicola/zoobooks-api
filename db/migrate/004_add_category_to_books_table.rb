class AddCategoryToBooksTable < ActiveRecord::Migration[5.0]
  def change
    change_table :books do |t|
      t.string :category
    end
  end
end