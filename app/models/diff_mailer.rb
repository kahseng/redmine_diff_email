class DiffMailer < ActionMailer::Base
  def diff_notification(diff, changeset)

    # Only send to developers
    recipients changeset.repository.project.users.select{|u|
      u.mail &&
      u.roles_for_project(changeset.repository.project).map(&:name).include?("Developer")
    }.map{ |u|
      u.mail
    }

    project_name = changeset.repository.project.name
    author = changeset.author.to_s
    subject "[#{project_name}] Commit by #{author}: #{changeset.short_comments}"
    #content_type 'multipart/alternative'

    part :content_type => "text/html",
      :body => render_message("diff_notification.text.html.rhtml",
                :project_name => project_name,
                :author => author,
                :diff => diff,
                :changeset => changeset)

    attachment 'text/plain' do |a|
      a.filename = "changeset_rev_#{changeset.revision}.diff"
      a.body = diff.join
    end
  end
end
