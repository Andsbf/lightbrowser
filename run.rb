require_relative './config.rb'

Page.destroy_all
User.destroy_all
User.create(name: 'Anderson')
LightBrow::Browser.new.run
