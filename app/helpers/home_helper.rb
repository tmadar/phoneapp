module HomeHelper
  def nice_time(time)
    text = if Time.now.localtime.to_date == time.localtime.to_date
      "Today"
    elsif (Time.now - 1.day).localtime.to_date == time.localtime.to_date
      "Yesterday"
    elsif (Time.now + 1.day).localtime.to_date == time.localtime.to_date
      "Tomorrow"
    elsif (Time.now).localtime.to_date.cweek == time.localtime.to_date.cweek
      "#{time.strftime("%A")}"
    else
      "#{time.strftime("%D")}"
    end
    
    return "#{text} #{time.strftime("%H:%M")}"
  end
  
  alias :nice_date :nice_time
  
  def user_printer(user)
    call.user ? (call.user.name ? call.user.name : call.user.email) : "- Unassigned - "
  end
end
