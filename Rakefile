require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/frett'

Hoe.plugin :newgem

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'frett' do
  self.developer 'johannes-kostas goetzinger', 'dbldots@gmail.com'
  self.rubyforge_name       = self.name
  self.extra_deps           = [
    ['daemons','>= 1.1.8'],
    ['ferret','>= 0.11.8.4'],
    ['listen','>= 0.4.7'],
    ['ptools','>= 1.2.2'],
    ['mime-types','>= 1.19']
  ]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
