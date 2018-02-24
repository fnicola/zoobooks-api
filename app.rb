# app.rb
require "sinatra"
require 'sinatra/activerecord'

class Nicola < ActiveRecord::Base
  validates :title, presence: true
end

class App < Sinatra::Base
  get "/" do
    nicola = Nicola.new(title: "nicola")
    nicola.title
  end
end


