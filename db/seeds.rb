# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'csv'

def fetch_file(table)
  model     = table.classify.constantize
  file_path = Rails.root.join('db','seeds', "#{table}.csv").to_path
  objects   = []
  CSV.foreach(file_path, {headers: true}) do |row|
    row         = row.to_hash
    row['code'] = row['name_en'].underscore unless row['code']
    objects << row
  end
  model.update_or_create!('code', objects, {update_if_exists: true})
  puts "Table #{table} was populated"
end

# Rails.application.eager_load!

puts '=======================Start Seed Dictionaries ======================'

exclude_seed_tables = []
(Base::SeedModel.tables - exclude_seed_tables).map { |model| fetch_file(model) }

puts '=======================End Seed Dictionaries ========================'