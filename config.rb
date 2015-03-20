require 'active_record'
require 'pry'
require 'database_cleaner'
require 'rspec'
require 'date'
require 'pry-nav'
require 'bundler/setup' 
require "net/http"
require "uri"
require 'nokogiri'
require 'colorize'

require_relative 'lib/light_brow/browser'
require_relative 'lib/light_brow/html_page'

DatabaseCleaner.strategy = :truncation

DATABASE = 'development'

puts "Connecting to 'db/#{DATABASE}.sqlite3' db ..."
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => "db/#{DATABASE}.sqlite3"
)

require_relative 'app/models/user'
require_relative 'app/models/page'
# Note: add any other models / classes that need to be required here (eg: Teacher)
