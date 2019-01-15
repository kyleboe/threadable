require 'pry'
module Threadable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      # Need to build 3 classes/tables ThreadableEvent, Threadable, Threaded
      desc 'does a thing'
      def raise_a_test
        puts 'do the thing'
      end

      def raise_another_test
        binding.pry
      end

      private

      def generate_model(name)
        invoke "active_record:model", [name], migration: false unless model_exists?(name) && behavior == :invoke
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end