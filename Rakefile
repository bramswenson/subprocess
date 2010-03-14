require 'rubygems'
gem 'hoe', '>= 2.1.0'
gem 'rspec', '<= 1.3.0'
require 'hoe'
require 'fileutils'
require './lib/subprocess'

Hoe.plugin :newgem
# Hoe.plugin :website
Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'subprocess' do
  self.developer 'Bram Swenson', 'bram@craniumisajar.com'
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['rspec','>= 2.0.0.beta.3']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

remove_task :default
task :default => [:spec, :features]
