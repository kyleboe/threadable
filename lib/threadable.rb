# frozen_string_literal: true

module Threadable
  def is_threadable(options = {})
    has_many :threadable_events, as: :record, dependent: :destroy
  end

  def is_threaded(options = {})
    has_many :threadable_events, as: :threadable, dependent: :destroy
  end

  def has_threaded(klass)
    has_many klass.to_s.downcase.pluralize.to_sym, through: :threadable_events, source: :record, source_type: klass.to_s.classify
  end
end

ActiveRecord::Base.send :extend, Threadable
