require "bundler/gem_tasks"

task :default => :spec

task :spec do
  system 'rspec'
end

task :build do
  system 'gem build spank.gemspec'
end

task :publish => :build do
  system 'gem push *.gem'
end
