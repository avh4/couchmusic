SCRATCH_DB = 'http://localhost:5984/couchmusic-scratch'

task :default => [:test, :install]

desc "Build the gem"
task :build do
  sh 'gem build couchmusic.gemspec'
end

desc "Install the gem locally"
task :install => [:build] do
  sh 'gem install couchmusic-*.gem'
end

desc "Run tests"
task :test do
  sh 'cucumber src/features/'
end

namespace :scratch do
  # desc "Upload fixture documents to the scratch database"
  task :seed do
    sh "kanso upload fixtures #{SCRATCH_DB}"
  end

  # desc "Upload design documents and attachements to the scratch database"
  task :push do
    sh "kanso push #{SCRATCH_DB}"
  end

  # desc "Delete the scratch database"
  task :delete do
    sh "curl -X DELETE #{SCRATCH_DB}"
  end

  desc "Reset the scratch database"
  task :reset => ['scratch:delete', 'scratch:push', 'scratch:seed']
end
