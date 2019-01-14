# frozen_string_literal: true

module Threadable
  def is_threadable(options = {})
     has_many :events, as: :record, dependent: :destroy
  end

  def is_threaded(options = {})
    has_many :events, as: :threadable, dependent: :destroy
  end
end

ActiveRecord::Base.send :extend, Threadable