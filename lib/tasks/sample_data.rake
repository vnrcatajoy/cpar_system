namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do
    #add sample Departments
    Department.create!(name: 'Administration')
    Department.create!(name: 'Maintainance')
    Department.create!(name: 'Development')
    Department.create!(name: 'Verification')

    #add sample User Types
    UserType.create!(name: 'System Administrator')
    UserType.create!(name: 'Department Head')
    UserType.create!(name: 'Responsible Officer')
    UserType.create!(name: 'Incident Manager')
    UserType.create!(name: 'Auditor')
    UserType.create!(name: 'Employee')

    #add sample Users
    admin1 = User.create!(name: 'Nico Catajoy', 
                  email: 'vnrcatajoy@gmail.com',
                  phone: '5191568',
                  mobile: '09173068540',
                  type_id: 1,
                  department_id: 1,
                  password: 'password',
                  password_confirmation: 'password')
    admin1.toggle!(:admin)
    admin1.toggle!(:with_role)

    admin2 = User.create!(name: 'Homer Isidro', 
                  email: 'homer.isidro@gmail.com',
                  phone: '1234567',
                  mobile: '09123456789',
                  type_id: 1,
                  department_id: 1,
                  password: 'password',
                  password_confirmation: 'password')
    admin2.toggle!(:admin)
    admin2.toggle!(:with_role)

    #Note: it accepted email like qmr@.a.com before, with extra misplaced dot
    User.create!(name: 'Isi QMR', 
                  email: 'qmr@a.com',
                  phone: '1234567',
                  mobile: '09123456789',
                  type_id: 4,
                  department_id: 2,
                  password: 'password',
                  password_confirmation: 'password')

    User.create!(name: 'Dept Head', 
                  email: 'dept@a.com',
                  phone: '1234567',
                  mobile: '09123456789',
                  type_id: 2,
                  department_id: 1,
                  password: 'password',
                  password_confirmation: 'password')

    User.create!(name: 'Off Icer', 
                  email: 'officer@a.com',
                  phone: '1234567',
                  mobile: '09123456789',
                  type_id: 3,
                  department_id: 1,
                  password: 'password',
                  password_confirmation: 'password')

    User.create!(name: 'Audi Thor', 
                  email: 'auditor@a.com',
                  phone: '1234567',
                  mobile: '09123456789',
                  type_id: 5,
                  department_id: 2,
                  password: 'password',
                  password_confirmation: 'password')

    20.times do |n|
      name = Faker::Name.name
      email = Faker::Internet.email
      type_id = (n%6) + 1
      phone = Faker::PhoneNumber.phone_number
      mobile = Faker::PhoneNumber.cell_phone
      department_id = (n%4) + 1
      password = "password#{n}"
      password_confirmation = "password#{n}"
      User.create!(name: name,
                    email: email,
                    type_id: type_id,
                    phone: phone,
                    mobile: mobile,
                    department_id: department_id,
                    password: password,
                    password_confirmation: password_confirmation)
    end

    #add sample IssueStatus
    IssueStatus.create!(name: 'New')
    IssueStatus.create!(name: 'Verified')
    IssueStatus.create!(name: 'Investigating')
    IssueStatus.create!(name: 'Correcting')
    IssueStatus.create!(name: 'Tested')
    IssueStatus.create!(name: 'Closed')
    IssueStatus.create!(name: 'Rejected')

    #add sample IssueImpact
    IssueImpact.create!(name: '1-Critical')
    IssueImpact.create!(name: '2-Major')
    IssueImpact.create!(name: '3-Minor')

    #add Action Plan Statuses
    ActionPlanStatus.create!(name: 'New')
    ActionPlanStatus.create!(name: 'Verified')
    ActionPlanStatus.create!(name: 'Implemented')
    ActionPlanStatus.create!(name: 'Closed')
    ActionPlanStatus.create!(name: 'Rejected')

    #add sample IssueType
    5.times do |n|
      IssueType.create!(name: "Issue#{n}")
    end

    #add sample ISO NC Types
    5.times do |n|
      IsoNc.create!(title: "IsoNc#{n}")
    end

    #add sample Issues
    Issue.create!(title: 'ITDC Slow Internet Connection', 
                    description: 'Low bandwidth', 
                    user_id: 1, 
                    impact_id: 1, 
                    status_id: 1, 
                    department_id: 1,
                    type_id: 1,
                    iso_nc_id: 1)

    10.times do |i|
      title = "Sample Title#{i+1}"
      description = "Sample Description#{i+1}"
      user_id = i + 1 
      impact_id = (i%3) + 1
      status_id = (i%5) + 1
      department_id = (i%4) + 1
      type_id = (i%5) + 1
      iso_nc_id = (i%5) + 1

      Issue.create!(title: title, 
                      description: description,
                      user_id: user_id,
                      impact_id: impact_id,
                      status_id: status_id,
                      department_id: department_id,
                      type_id: type_id,
                      iso_nc_id: iso_nc_id)
    end

    10.times do |a|
      
      description = "This is the #{a}th Action Plan for the #{a}th Issue. Edit this #{a}th description later on."
      stat_id = (a%5) + 1

      actplan = ActionPlan.create!(description: description, 
                  issue_id: a+1, ap_status_id: stat_id)

      # Can't populate-generate Activities under Action Plan because one way or the
      # other, either action_plan_id or user_id of the Activity will be left blank,
      # which will result to create! failing

    end

  end
end