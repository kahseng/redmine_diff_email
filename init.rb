require 'rubygems'
require "dispatcher"
require 'redmine'
require 'changeset_patch'

Redmine::Plugin.register :redmine_redmine_diff_email do
  name 'Redmine Redmine Diff Email plugin, fork of http://github.com/genbit/redmine_diff_email'
  author 'Sergey Generalov <sergey@genbit.ru>'
  description 'This is a plugin for Redmine'
  version '0.0.2'
end

Dispatcher.to_prepare do
  Changeset.send(:include, ChangesetPath)
end


# TODO: Check, is it right?
#ProjectCustomField.find_by_name("Send Diff Emails") ||
#  ProjectCustomField.create(:name => "Send Diff Emails",
#                            :field_format => "bool",
#                            :is_required => true,
#                            :is_for_all => false,
#                            :default_value => nil
#                            )
