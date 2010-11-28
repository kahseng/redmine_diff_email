require_dependency 'changeset'

module ChangesetPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_create :send_diff_emails
    end
  end
  module InstanceMethods
    def send_diff_emails
      DiffMailer.deliver_diff_notification(self)
    end
  end
end
