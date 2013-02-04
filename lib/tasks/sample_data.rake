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
    UserType.create!(name: 'Employee')
    UserType.create!(name: 'Department Head')
    UserType.create!(name: 'Incident Manager')
    UserType.create!(name: 'Auditor')
    UserType.create!(name: 'Customer')

    #add sample Users
    User.create!(name: 'Nico Catajoy', 
                  email: 'vnrcatajoy@gmail.com',
                  phone: '5191568',
                  mobile: '09173068540',
                  type_id: 1,
                  department_id: 1)

    20.times do |n|
      name = Faker::Name.name
      email = Faker::Internet.email
      type_id = (n%6) + 1
      phone = Faker::PhoneNumber.phone_number
      mobile = Faker::PhoneNumber.cell_phone
      department_id = (n%4) + 1
      User.create!(name: name,
                    email: email,
                    type_id: type_id,
                    phone: phone,
                    mobile: mobile)
    end

    #add sample IssueStatus
    IssueStatus.create!(name: 'New')
    IssueStatus.create!(name: 'Investigating')
    IssueStatus.create!(name: 'Correcting')
    IssueStatus.create!(name: 'Tested')
    IssueStatus.create!(name: 'Closed')

    #add sample IssueImpact
    IssueImpact.create!(name: '1-Critical')
    IssueImpact.create!(name: '2-Major')
    IssueImpact.create!(name: '3-Minor')

    #add sample Issues
    Issue.create!(title: 'ITDC Slow Internet Connection', 
                    description: 'Low bandwidth', 
                    user_id: 1, 
                    impact_id: 1, 
                    status_id: 1, 
                    department_id: 1)

    5.times do |i|
      title = "Sample Title#{i}"
      description = "Sample Description#{i}"
      user_id = i + 1 
      impact_id = (i%3) + 1
      status_id = (i%5) + 1
      department_id = (i%4) + 1

      Issue.create!(title: title, 
                      description: description,
                      user_id: user_id,
                      impact_id: impact_id,
                      status_id: status_id,
                      department_id: department_id)
    end

  end
end