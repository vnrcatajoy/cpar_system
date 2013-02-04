require 'spec_helper'

describe "Issues" do
  before do
    #create default User Types
    UserType.create name: 'Administrator'
    UserType.create name: 'Customer'

    #create a default User
    User.create name: 'Nico Catajoy', phone: '5191568', mobile: '09173068540', email: 'vnrcajoy@gmail.com', type_id: 1

    #create default Departments
    Department.create name: 'Admin'
    Department.create name: 'Maintainance'

    #create default Impact Types
    IssueImpact.create name: '1-Critical'
    IssueImpact.create name: '2-Major'
    IssueImpact.create name: '3-Minor'

    #create default Issue Status
    IssueStatus.create name: 'New'
    IssueStatus.create name: 'Investigating'
    IssueStatus.create name: 'Correcting'
    IssueStatus.create name: 'Closed'

  	#create an issue with fixed params
    @issue = Issue.create title: 'ITDC Slow Internet Connection', description: 'Low bandwidth', user_id: 1, impact_id: 1, status_id: 1, department_id: 1
    
  end

  describe "GET /issues" do
    it "displays all issues with title, originator name, impact and status" do
      visit issues_path       

      page.should have_content 'ITDC Slow Internet Connection'
      page.should have_content 'Nico Catajoy'
      page.should have_content '1-Critical'
      page.should have_content 'New'

    end

    it "navigates to add issue page" do
   	  visit issues_path
      click_link 'Report New Issue'

      current_path.should == new_issue_path

      page.should have_content 'Title'
      page.should have_content 'Description'
      page.should have_content 'Originator'
      page.should have_content 'Originator Email'
      page.should have_content 'Group in Charge'
      page.should have_content 'Type'
      page.should have_content 'Impact'
      page.should have_content 'ISO Reference ID'
      #add cause and action plan

    end

    it "creates a new issue" do
      visit new_issue_path

      fill_in 'Title', with: 'No projects'
      fill_in 'Description', with: 'Lalala just going to test the description box'
      fill_in 'Originator', with: 1
      fill_in 'Group in Charge', with: 1
      fill_in "Type", with: 1
      fill_in "Impact", with: 1
      fill_in "ISO Reference", with: 1

      click_button 'Create Issue'

      current_path.should == issues_path

      page.should have_content 'No projects'
      page.should have_content 'Nico Catajoy'
      page.should have_content '1-Critical'
      page.should have_content 'New'

      save_and_open_page

    end
  end

end
