desc "Automatically migrate db"
task :automigrate do
  # Always automigrate unless on non-first CF instance
  unless ENV["VCAP_APPLICATION"] && JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] != 0
    puts "Migrating database..."
    Rake::Task["environment"].invoke
    Rake::Task["db:migrate"].invoke
  end
end
