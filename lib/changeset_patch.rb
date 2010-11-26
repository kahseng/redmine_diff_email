require_dependency 'changeset'

module ChangesetPath
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_create :send_diff_emails
    end
  end
  module InstanceMethods
    def send_diff_emails
      logger.info "Sends called+++++++++++++++++++++++++++++++++++" if logger && logger.debug?
#      if repository.project.custom_value_for(CustomField.find_by_name("Send Diff Emails"))
      if previous
        DiffMailer.deliver_diff_notification(repository.diff("", previous.revision, revision), self)
       end
#      end
    end
  end
end
