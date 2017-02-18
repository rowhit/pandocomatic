require "rake/testtask"
require "yard"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "lib/pandocomatic"
  t.test_files = FileList["test/test_helper.rb", "test/unit/*.rb", "test/spec/*.rb"]
  t.warning = false
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

task :build do
  sh "gem build pandocomatic.gemspec; mv *.gem releases"
end

task :default => :test
