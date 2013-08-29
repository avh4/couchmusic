
task :default => [:install]

desc "Build the gem"
task :build do
  sh 'gem build couchmusic.gemspec'
end

desc "Install the gem locally"
task :install => [:build] do
  sh 'gem install couchmusic-*.gem'
end