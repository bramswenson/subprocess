require 'rubygems'
gem 'hoe', '>= 2.1.0'
#gem 'rspec', '<= 1.3.0'
require 'hoe'
require 'fileutils'
require './lib/subprocess'

Hoe.plugin :newgem
# Hoe.plugin :website
Hoe.plugin :cucumberfeatures

$hoe = Hoe.spec 'subprocess' do
  self.developer 'Bram Swenson', 'bram@craniumisajar.com'
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

remove_task :default
task :default => [:spec, :features]
