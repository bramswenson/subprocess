$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

begin
  require 'net/ssh'
rescue LoadError
  require 'rubygems'
  require 'net/ssh'
end

module Subprocess
  VERSION = '0.0.2'
end

require 'subprocess/popen'
require 'subprocess/popen_remote'
