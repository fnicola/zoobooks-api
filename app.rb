# app.rb
require "sinatra"
require 'sinatra/activerecord'

class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  accepts_nested_attributes_for :authors

  validates :isbn, uniqueness: true

  def self.book_for isbn
    uri = URI("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}")
    result = Net::HTTP.get(uri)
    json_result = JSON.parse(result)
    puts isbn if json_result["items"].nil?
    return if json_result["items"].nil?
    volumeInfo = json_result["items"][0]["volumeInfo"]
    attributes = {}
    %w[title subtitle description publisher language publishedDate pageCount previewLink].each do |attribute|
      attributes[attribute.to_sym] = volumeInfo[attribute]
    end
    attributes[:isbn] = isbn
    attributes[:google_thumbnail] = volumeInfo["imageLinks"]["thumbnail"] if volumeInfo["imageLinks"]
    author_name = volumeInfo["author"]
    authors = { title: author_name } if author_name
    result = []
    json_result["items"][0]["volumeInfo"]["authors"].each {|author| result << {name: author}}
    authors ||= result
    attributes[:authors_attributes] = authors
    Book.create(attributes)
  end
end

class Author < ActiveRecord::Base
  has_and_belongs_to_many :books
end

class App < Sinatra::Base

  before do
    content_type 'application/json'
    headers "Access-Control-Allow-Origin" => "*"
  end

  get '/' do
    books = Book.all
    books.to_json(:include => :authors)
  end
end


