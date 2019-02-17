# frozen_string_literal: true

module Threadable
  module Models
    module Recordable
      extend ActiveSupport::Concern

      def create_and_log_event(params, threadable, user = nil)
        assign_attributes(params)
        return false unless save

        log_event(action: 'create', user: user, threadable: threadable, record: self, attr_name: nil)
      end

      def update_and_log_event(params, threadable, user = nil)
        assign_attributes(params)
        if changes.any? && valid?
          changes.each do |attr_name, changes|
            log_event({ action: 'update', user: user, threadable: threadable, record: self, attr_name: attr_name }, changes)
          end
        end
        save
      end

      def log_event(attr_hash, changes = [nil, nil])
        event_params = { record_was: changes[0], record_is: changes[1] }.merge(attr_hash)
        Event.create!(event_params)
      end
    end
  end
end
