# -*- encoding: utf-8 -*-
require File.expand_path("../lib/zap/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "zap"
  s.version     = Zap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/zap"
  s.summary     = "Zap is a simpler BOOM. Plus, it's one character shorter!"
  s.description = "Zap is a simple command line key-value store. There are no collections, just a single namespace, and only three letters in the command. ZAP!"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "zap"
  
  s.add_dependency 'yajl-ruby'

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
