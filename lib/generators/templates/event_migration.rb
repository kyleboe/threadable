# frozen_string_literal: true

class CreateThreadableEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :threadable_events do |t|
      t.references :threadable, polymorphic: true, index: true
      t.references :record, polymorphic: true, index: true
      t.string :action, null: false
      t.string :attribute_name
      t.string :record_was
      t.string :record_is
      # t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
