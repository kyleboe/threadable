# frozen_string_literal: true

module Threadable
  module Models
    module Recordable
      extend ActiveSupport::Concern

      def create_and_log_event(params, user = nil, threadable, record = self)
        assign_attributes(params)
        return false unless save
        log_event('create', user, threadable, record)
      end

      def update_and_log_event(params, user = nil, threadable, record = self)
        assign_attributes(params)
        if changes.any? && valid?
          changes.each do |attr_name, changes|
            log_event('update', user, threadable, record, attr_name, changes)
          end
        end
        save
      end

      def log_event(action, user, threadable, record, attr_name = nil, changes = [nil, nil])
        Event.create!(action: action,
                      user: user,
                      threadable: threadable,
                      record: record,
                      attr_name: attr_name,
                      record_was: changes[0],
                      record_is: changes[1])
      end
    end
  end
end
