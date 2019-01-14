require 'pry'
class ThreadableGenerator < Rails::Generators::Base
  # Need to build 3 classes/tables ThreadableEvent, Threadable, Threaded
  
  def raise_a_test
    
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