# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 4) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "nationality"
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "author_id", null: false
    t.index ["author_id"], name: "index_authors_books_on_author_id"
    t.index ["book_id"], name: "index_authors_books_on_book_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "isbn"
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.string "publisher"
    t.string "publishedDate"
    t.integer "pageCount"
    t.string "language"
    t.string "previewLink"
    t.string "google_thumbnail"
    t.string "category"
  end

end
