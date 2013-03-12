module Qmr::IssuesHelper
  def status_change(stat_id)
  	case stat_id
  	when 1
  		2
  	when 2
  		3
  	when 3
  		4	
  	when 4
  		5
  	else
  		5
  	end
  end

  def status_display(stat_id)
  	IssueStatus.find(stat_id+1).name
  end
end
