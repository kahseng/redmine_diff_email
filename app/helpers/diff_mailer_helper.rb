require_dependency 'repositories_helper'
module DiffMailerHelper
  include RepositoriesHelper

  def replace_css(class_name)
    css = {
      'filename'    => 'background-color: #e4e4d4; text-align: left; padding: 0.2em',
      'line-num'    => 'border: 1px solid #d7d7d7; font-size: 0.8em; text-align: right; width: 2%; padding-right: 3px; color: #999;',
      'diff_out'    => 'background: #fcc;',
      'diff_in'     => 'background: #cfc;',
      'line-code'   => 'margin: 0px; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -o-pre-wrap; font-size: 1.2em',
      'filecontent' => 'border: 1px solid #ccc;  border-collapse: collapse; width:98%;'
    }

    if css[class_name]
      %Q[style="#{css[class_name]}"]
    else
      ''
    end
  end

  def format_diff(diff)
    diff = Redmine::UnifiedDiff.new(diff, :type => 'inline', :max_lines => Setting.diff_max_lines_displayed.to_i)

    result = ''
    diff.each do |table_file|
      result += %Q[<table cellspacing="0" cellpadding="0" #{replace_css("filecontent")}>
      <thead>
      <tr><th colspan="3" #{replace_css("filename")}>#{table_file.file_name}</th></tr>
      </thead>
      <tbody>]
      prev_line_left, prev_line_right = nil, nil
      table_file.each_line do |key, line|
         if prev_line_left && prev_line_right && (line.nb_line_left != prev_line_left + 1) && (line.nb_line_right != prev_line_right+1)
          result += %Q[
            <tr>
              <th #{replace_css("line-num")}>...</th><th #{replace_css("line-num")}>...</th><td></td>
            </tr>]
        end
        result += %Q[
          <tr>
            <th #{replace_css("line-num")}>#{line.nb_line_left}</th>
            <th #{replace_css("line-num")}>#{line.nb_line_right}</th>]
        if line.line_left.empty?
          result += %Q[<td #{replace_css(line.type_diff_right)}">
              <pre #{replace_css("line-code")}>#{to_utf8 line.line_right}</pre>
            </td>]
        else
          result += %Q[
            <td #{replace_css(line.type_diff_left)}">
              <pre #{replace_css("line-code")}>#{to_utf8 line.line_left}</pre>
            </td>]
        end

        result += '</tr>'

        prev_line_left = line.nb_line_left.to_i if line.nb_line_left.to_i > 0
        prev_line_right = line.nb_line_right.to_i if line.nb_line_right.to_i > 0
      end
      result += %Q[
      </tbody>
      </table>]
    end

    result
  end
end

