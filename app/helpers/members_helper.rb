module MembersHelper

  def check(item)
    if item == ""
      mark = '&#8212;'
      mark.html_safe
    else
      item
    end
  end

  def check_templates(member)
    if Template.where(member_id: member.id).present?
      @template = Template.where(member_id: member.id).first
    end
  end

end
