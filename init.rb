require 'rubygems'
require "dispatcher"
require 'redmine'
require 'changeset_patch'

Redmine::Plugin.register :redmine_redmine_diff_email do
  name 'Redmine Diff Email Plugin'
  author 'Kah Seng Tay, Sergey Generalov, Lamar, Ivan Evtuhovich'
  description 'This is a plugin for Redmine that sends diff emails on commits.'
  version '0.0.4'
end

Dispatcher.to_prepare do
  Changeset.send(:include, ChangesetPatch)

  field = UserCustomField.find_by_name 'Send diff email'
  unless field
    UserCustomField.create!(:name => 'Send diff email', :field_format => 'bool',
                            :editable => true)
  end
end
