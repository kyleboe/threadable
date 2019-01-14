# frozen_string_literal: true

require 'rails/generators/active_record'
require 'generators/threadable/orm_helpers'

module ActiveRecord
  module Generators
    class ThreadableGenerator < ActiveRecord::Generators::Base
      # argument :attributes, type: :array, default: [], banner: "field:type field:type"

      # class_option :primary_key_type, type: :string, desc: "The type for primary key"

      include Threadable::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_threadable_migration
        if (behavior == :invoke && models_exist?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "#{migration_path}/add_threadable_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "migration.rb", "#{migration_path}/create_threadable_#{table_name}.rb", migration_version: migration_version
        end
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_threadable_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def migration_data
<<RUBY
      t.references :threadable, polymorphic: true, index: true
      t.references :record, polymorphic: true, index: true
      t.string :attr_name
      t.string :action, null: false
      t.string :record_was
      t.string :record_is
      t.belongs_to :user, index: true
RUBY
      end

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

     def migration_version
       if rails5_and_up?
         "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
       end
     end

     def primary_key_type
       primary_key_string if rails5_and_up?
     end

     def primary_key_string
       key_string = options[:primary_key_type]
       ", id: :#{key_string}" if key_string
     end
    end
  end
end
