require_relative './config.rb'


User.destroy_all
User.create(name: 'Anderson')
LightBrow::Browser.new.run
