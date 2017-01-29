#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'coffee-script'
require 'sass'
require 'sinatra'
require 'slim'
require 'tilt/erubis'
require 'tilt/coffee'
require 'tilt/sass'
require_relative 'icon_set'
require_relative 'config/icon_sets.rb'

SETS = {}
ICON_SETS.sort.each do |set|
  puts set.inspect
  SETS[set.first] = IconSet.new(set[0], set[1], license: set[2], license_hint: set[3].presence)
end

configure do
  mime_type :svg, 'image/svg+xml'
end

get('/') do
  slim :'index.html'
end

ONE_WEEK = 86_400 * 7
get '/icon/:set/*' do
  set = SETS.fetch(params['set'])

  icon_name = params['splat'].first
  icon_name.gsub!('..', '')
  filename = [set.path, icon_name].join('/')

  expires ONE_WEEK, :public
  last_modified File.mtime(filename)
  send_file filename
end

get '/license/:set' do
  set = SETS.fetch(params['set'])
  send_file set.license
end

get '/favicon/*' do
  send_file File.dirname(__FILE__) +  "/views/favicon/#{params['splat'].first}"
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
