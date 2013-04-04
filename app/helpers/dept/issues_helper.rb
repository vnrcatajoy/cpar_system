module Dept::IssuesHelper
	def found_dept(issue)
		found_dep=false
		if issue.department_id == current_user.department_id
			found_dep = true
		else
			@nrds = NextResponsibleDepartment.where("issue_id = ?", issue.id)
    		@nrds.each do |n|
      			if n.department_id == current_user.department_id
        			found_dep = true
      			end
    		end
		end
		found_dep
	end
end
