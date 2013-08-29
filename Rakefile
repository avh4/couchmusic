
task :default => [:install]

desc "Build the gem"
task :build do
  sh 'gem build couchmusic.gemspec'
end

desc "Install the gem locally"
task :install => [:build] do
  sh 'gem install couchmusic-*.gem'
end

namespace :test do
  desc "Upload fixture documents to the test database"
  task :seed do
    sh 'kanso upload fixtures http://localhost:5984/couchmusic-test'
  end

  desc "Upload design documents and attachements to the test database"
  task :push do
    sh 'kanso push http://localhost:5984/couchmusic-test'
  end
end
