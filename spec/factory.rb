FactoryGirl.define do
  factory :user do
    name "Nico Catajoy"
    email "vnrcatajoy@gmail.com"
    type_id "1"
    department_id "1"
    phone "5191568"
    mobile "09173068540"
  end

  factory :department do
    name "Administration"
    description "Sample description"
  end

  # factory :issue do
  # 	title "Sample Title"
  # 	description "Sample Description"
  # 	type_id 1
  # 	status_id 1
  # 	impact_id 1
  # 	user_id 1
  # 	department_id 1
  # 	cause_id 1
  # 	action_plan_id 1
  # end

end