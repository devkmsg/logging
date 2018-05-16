require 'json'

task :clean do
  rm_rf 'build'
end

desc 'Update cookbook'
task :update do
  sh 'chef update'
end

desc 'Export cookbook'
task :export => [:clean] do
  mkdir 'build'
  sh 'chef export Policyfile.rb -a build'
end

desc 'Upload policy to S3'
task :upload => [:export] do
  lock = ::JSON.parse(::File.read('Policyfile.lock.json'))
  version = lock['revision_id']
  archive = Dir.glob("build/*#{version}.tgz").first
  sh "aws s3 cp #{archive} s3://artifacts-backend/roles/ --storage-class REDUCED_REDUNDANCY"
end

task :default => [:update, :export, :upload]