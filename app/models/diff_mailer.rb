class DiffMailer < ActionMailer::Base

  def self.default_url_options
    h = Setting.host_name
    h = h.to_s.gsub(%r{\/.*$}, '') unless Redmine::Utils.relative_url_root.blank?
    { :host => h, :protocol => Setting.protocol }
  end

  def diff_notification(changeset)
    diff = changeset.repository.diff("", changeset.revision, nil)

    # Only send to users, who want to receive this emails
    recipients changeset.repository.project.users.select{|u|
      custom_value = u.custom_field_values.select { |value| value.custom_field.name == 'Send diff email' }.first
      u.mail && custom_value && custom_value.value == '1'
    }.map{ |u|
      u.mail
    }

    from Setting.mail_from

    project = changeset.repository.project
    author = changeset.author.to_s
    subject "[#{project.name}] Commit by #{author}: #{changeset.short_comments}"

    part :content_type => "text/html",
      :body => render_message("diff_notification.text.html.rhtml",
                :project => project,
                :author => author,
                :diff => diff,
                :changeset => changeset,
                :changeset_url => url_for(:controller => 'repositories', :action => 'diff', :rev => changeset.revision, :id => project.id),
                :project_url => url_for(:controller => 'projects', :action => 'show', :id => project.id))

    attachment 'text/plain' do |a|
      a.filename = "changeset_rev_#{changeset.revision}.diff"
      a.body = diff.join
    end

  end
end
