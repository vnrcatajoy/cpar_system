module UsersHelper
    def show_department(user)
    	case user.department_id
    	when 1
    		"DCS"
    	when 2
    		"Engineering"
    	when 3
    		"ITDC"
    	when 4
    		"Others"
    	else
    		"invalid department"
    	end
	end
	#still to be edited once Departments and User Types finalized
    #there are actually 6 User types, other Users randomized through populate end up in invalid user type
	def show_usertype(user)
		case user.type_id
    	when 1
    		"Student"
    	when 2
    		"Professor"
    	when 3
    		"Department Head"
    	when 4
    		"Admin"
    	else
    		"invalid user type"
    	end
	end
end
