# app.rb
require "sinatra"
require 'sinatra/activerecord'
require 'pry'

class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  accepts_nested_attributes_for :authors

  validates :isbn, uniqueness: true

  def self.book_lookup isbn
    uri = URI("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}")
    result = JSON.parse(Net::HTTP.get(uri))
  end

  def self.book_for(isbn, category)
    json_result = book_lookup(isbn)
    puts json_result
    puts isbn if json_result["items"].nil? #TODO replace with logger
    return if json_result["items"].nil?
    volumeInfo = json_result["items"][0]["volumeInfo"]
    attributes = {}
    %w[title subtitle description publisher language publishedDate pageCount previewLink].each do |attribute|
      attributes[attribute.to_sym] = volumeInfo[attribute]
    end
    attributes[:isbn] = isbn
    attributes[:category] = category
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

  get '/:isbn' do
    begin
      book = Book.find_by_isbn(params['isbn'])
      raise "book with isbn: #{params['isbn']} not found" unless book
      book.to_json(:include => :authors)
    rescue => e
      status 404
      body ({"error" => e.message}.to_json)
    end
  end

  post '/add_book' do
    payload = JSON.parse(request.body.read)
    puts payload["authors"]
    authors = payload["authors"].collect{|author|{name: author}}
    book_params = payload.slice(*Book.column_names)
    book_params[:authors_attributes] = authors
    begin
      book = Book.create!(book_params)
      status 201
      body book.to_json(:include => :authors)
    rescue => e
      status 400
      body e.message.to_json
    end
  end

  delete '/delete_book/:isbn' do
    begin
      Book.find_by(isbn: params['isbn']).destroy
      status 200
    rescue => e
      status 400
      body e.message.to_json
    end
  end
end
