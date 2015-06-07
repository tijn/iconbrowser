#!/usr/bin/env ruby

require 'coffee-script'
require 'sass'
require 'sinatra'
require 'slim'
require_relative 'icon_set'
require_relative 'config/icon_sets.rb'

SETS = {}
ICON_SETS.sort.each do |set|
  SETS[set.first] = IconSet.new(set.first, set.last)
end

configure do
  mime_type :svg, 'image/svg+xml'
end

get('/') do
  slim :'index.html'
end

get '/icon/:set/*' do
  set = SETS.fetch(params['set'])

  icon_name = params['splat'].first
  icon_name.gsub!('..', '')
  filename = [set.path, icon_name].join('/')

  cache_control :public, :max_age => 86400 # may be cached for up to one day
  last_modified File.mtime(filename)
  send_file filename
end

get '/app.css' do
  sass :app
end

get "/sprint.min.js" do
  send_file File.dirname(__FILE__) + '/views/sprint.min.js'
end

get "/*.js" do
  filename = params[:splat].first
  coffee filename.to_sym
end
