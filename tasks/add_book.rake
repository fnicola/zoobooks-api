require 'net/http'
require 'json'
require 'active_record'
require 'csv'

namespace :bookshelf do
  desc "add books"
  task :add_books, [:path] do |_, args|
    path = args[:path]
    CSV.foreach(path, {:headers => true, :header_converters => :symbol}) do |row|
      isbn = row[:isbn]
      category = row[:category]
      Book.book_for(isbn, category)
    end
    # path = args[:path]
    # CSV.foreach(path, {:headers => true, :header_converters => :symbol}) do |row|
    #   isbn = row[:isbn]
    #   Book.book_for isbn
    # end
  end
end
