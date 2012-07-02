$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Frett
  VERSION = '0.0.1'
end

require 'rubygems'
%w(config adapter cli indexer search).each do |file|
  require File.join(File.expand_path(File.dirname(__FILE__)), "frett", file)
end
