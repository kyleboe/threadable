# frozen_string_literal: true

require 'pry'
module Threadable
  module Generators
    class ThreadGenerator < Rails::Generators::NamedBase
      # Need to build 3 classes/tables ThreadableEvent, Threadable, Threaded
      desc 'Adds activerecord relationships to specified models'

      def raise_another_test
        binding.pry
      end

      private

      def inject_threadable_content
        content = model_contents

        class_path = if namespaced?
                       class_name.to_s.split('::')
                     else
                       [class_name]
                     end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| '  ' * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path(class_path), class_path.last, content) if model_exists?(class_path)
      end

      def generate_model(name)
        invoke 'active_record:model', [name], migration: false unless model_exists?(name) && behavior == :invoke
      end

      def model_exists?(name)
        File.exist?(File.join(destination_root, model_path(name)))
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_create_threadable_events.rb$/).first
      end

      def migration_path
        if Rails.version >= '5.0.3'
          db_migrate_path
        else
          @migration_path ||= File.join('db', 'migrate')
        end
      end

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
      end

      def model_path(name)
        @model_path ||= File.join('app', 'models', "#{name}.rb")
      end
    end
  end
end