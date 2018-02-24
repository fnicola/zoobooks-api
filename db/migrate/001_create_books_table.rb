class CreateBooksTable < ActiveRecord::Migration[5.0]
	def change
		create_table :books do |t|
			t.string  :isbn
			t.string  :title
			t.string  :subtitle
			t.text    :description
			t.string  :publisher
			t.string  :publishedDate
			t.integer :pageCount
			t.string  :language
			t.string  :previewLink
			t.string  :google_thumbnail
		end
	end
end