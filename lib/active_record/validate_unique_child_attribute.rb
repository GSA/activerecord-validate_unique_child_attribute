require 'active_support/core_ext'

# Work around https://github.com/rails/rails/issues/4568 :-(
module ActiveRecord
  module ValidateUniqueChildAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def validates_uniqueness_of_child_attribute(relation, attribute, options = {}, &block)
        options.reverse_merge!(validate: false,
                               error_formatter: :default_duplicate_child_attribute_error_formatter)
        validate do |record|
          record.validate_uniqueness_of_child_attribute(relation, attribute, options, &block)
        end
      end
    end

    def validate_uniqueness_of_child_attribute(relation, attribute, options, &block)
      records = send(relation)
      records.each(&:valid?) if options[:validate]
      dups = detect_duplicate_child_attributes(records, attribute, options)
      dups.empty? || set_duplicate_child_attribute_errors(relation, attribute, dups, options, &block)
    end

    private

    def detect_duplicate_child_attributes(records, attribute, _options)
      values = records.map(&attribute)
      values.select { |v| values.count(v) > 1 }.uniq
    end

    def set_duplicate_child_attribute_errors(relation, attribute, dups, options, &block)
      proc = block_given? ? block : method(options[:error_formatter])
      errors.add(relation, proc.call(attribute, dups))
    end

    def default_duplicate_child_attribute_error_formatter(attribute, dups)
      s = attribute.to_s.singularize.humanize.downcase
      "The following #{dups.count == 1 ? "#{s} has" : "#{s.pluralize} have"} been duplicated: #{dups.map { |d| "'#{d}'" }.join(', ')}. Each #{s} should be added only once."
    end
  end
end
