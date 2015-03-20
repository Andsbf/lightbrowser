require 'rake'
require 'rspec/core/rake_task'
require 'active_support/all'
require 'active_record/schema_dumper'
require_relative 'config'
# require_relative 'lib/students_importer'
# require_relative 'lib/teachers_importer'


desc "create the database"
task "db:create" do
  touch "db/#{DATABASE}.sqlite3"
end

desc "drop the database"
task "db:drop" do
  rm_f "db/#{DATABASE}.sqlite3"
end

desc "dump the database" 
task "db:schema:dump" do
  filename = File.dirname(__FILE__) + '/db/schema.rb'
  File.open(filename, "w:utf-8") do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
end

desc "migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
task "db:migrate" do
  ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
  ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
  ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
    ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
  end
  Rake::Task["db:schema:dump"].invoke
end

desc "rollback the database (options: VERSION=x, VERBOSE=false, STEPS=1)."
task "db:rollback" do
  ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
  ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
  ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, ENV["SCOPE"] ? ENV["SCOPE"].to_i : 1)
  Rake::Task["db:schema:dump"].invoke
end

# desc "populate the test database with sample data"
# task "db:populate" do
#   StudentsImporter.new.import
#   TeachersImporter.new.import
#   StudentsTeachersDistribution.new.import
# end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

desc 'Create a new migration file'
task "db:migration" do
 File.open "#{'db/migrate/'+(`date +"%Y%m%d%H%M%S"`).chomp+'_new_migration.rb'}", "w"
end

desc "Run the specs"
RSpec::Core::RakeTask.new(:specs)

task :default => :specs
