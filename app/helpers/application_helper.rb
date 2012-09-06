module ApplicationHelper
  
  def th_sort_modifier(name)
    if name and name == params[:sort_by]
      return "sorted=\"#{params[:direction] == "1" ? "1" : "0"}\""
    end
    
    return ""
  end
  
  def th_span_modifier(name)
    if name and name == params[:sort_by]
      return "<span class=\"caret#{params[:direction] == "1" ? " up" : ""}\"></span>"
    end
    
    return ""
  end
  
end
