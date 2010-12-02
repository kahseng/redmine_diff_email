class AddUserCustomField < ActiveRecord::Migration
  def self.up
    UserCustomField.create!(:name => 'Send diff email',
                            :field_format => 'bool',
                            :editable => true)
  end

  def self.down
  end
end
