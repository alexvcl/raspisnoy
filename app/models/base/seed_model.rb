class Base::SeedModel < ApplicationRecord
    # might have special behavior in future; for the moment it's just convenient to track seedable models separately
    self.abstract_class = true

    class << self

      #Return code's (missing method's) object
      def method_missing(method)
        find_by(code: method)
      end

      def seedable_models
        @seedable_models ||= descendants.select { |child| !child.abstract_class }
      end
      alias :models :seedable_models

      def seedable_tables
        @seedable_tables ||= seedable_models.map(&:table_name)
      end
      alias :tables :seedable_tables

      def to_csv
        CSV.open("#{Rails.root}/tmp/#{self.name.tableize}.csv", 'wb', {force_quotes: true}) do |writer|
          writer << self.column_names - ['id']
          self.all.each do |c|
            writer << c.attributes.values - [c.id]
          end
        end
      end

    end

end