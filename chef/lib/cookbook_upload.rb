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
  cd 'build'
  sh 'chef export ../Policyfile.rb -a .'
end

task :default => [:update, :export]