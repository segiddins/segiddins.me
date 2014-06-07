desc "Initializes your working copy to have the correct submodules and gems"
task :bootstrap do
  puts "Updating submodules..."
  `git submodule update --init --recursive`

  puts "Installing gems"
  `bundle install`
end

require 'middleman-gh-pages'

task :deploy do
  Rake::Task["publish"].invoke
end

desc 'Runs the web server locally and watches for changes'
task :run do
  sh "middleman server --port 4567"
end
