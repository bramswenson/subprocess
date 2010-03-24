$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

begin
  require 'net/ssh'
  require 'json'
rescue LoadError
  require 'rubygems'
  require 'net/ssh'
  require 'json'
end
require 'timeout'

module Subprocess
  VERSION = '0.0.7'
end

require 'core_ext/hash'
require 'core_ext/process_status'
require 'subprocess/popen'
require 'subprocess/popen_remote'
