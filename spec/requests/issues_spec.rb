require 'spec_helper'

describe "Issues" do
  before do
    #create default User Types
    UserType.create name: 'Administrator'
    UserType.create name: 'Customer'

    #create a default User
    User.create name: 'Nico Catajoy', phone: '5191568', mobile: '09173068540', 
                email: 'vnrcatajoy@gmail.com', 
                type_id: 1, 
                password: 'password',
                password_confirmation: 'password'

    #create default Departments
    Department.create name: 'Administration'
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

    #create default Issue Types
    IssueType.create name: 'Process Related'
    IssueType.create name: 'KPI'
    IssueType.create name: 'Supplier Related'
    IssueType.create name: 'Top Priority'

    #create default ISO Non Conformance Types
    IsoNc.create title: '1A'
    IsoNc.create title: '1B'
    IsoNc.create title: '2A'
    IsoNc.create title: '2B'
    IsoNc.create title: '3A'
    IsoNc.create title: '3B'

  	#create an issue with fixed params
    @issue = Issue.create title: 'ITDC Slow Internet Connection', description: 'Low Bandwidth', user_id: 1, 
                          impact_id: 1, status_id: 1, department_id: 1, type_id: 4, iso_nc_id: 5
    
  end

  describe "GET /issues" do
    it "displays all issues with title, originator name, impact and status" do
      visit issues_path       

      page.should have_content 'ITDC Slow Internet Connection'
      page.should have_content 'Nico Catajoy'
      page.should have_content '1-Critical'
      page.should have_content 'New'

    end

    it "creates a new issue" do
      visit issues_path
      click_link 'Report New Issue'

      current_path.should == new_issue_path

      fill_in 'Title', with: 'No projects'
      fill_in 'Description', with: 'Lalala just going to test the description box'
      fill_in 'User', with: 1
      fill_in 'Department', with: 1
      fill_in "Type", with: 1
      fill_in "Impact", with: 1
      fill_in "Status", with: 1
      fill_in "ISO Reference ID", with: 1

      click_button 'Create Issue'

      current_path.should == issues_path

      page.should have_content 'No projects'
      page.should have_content 'Nico Catajoy'
      page.should have_content '1-Critical'
      page.should have_content 'New'

    end

    it "shows an issue" do
      visit issues_path
      find("#issue_#{@issue.id}").click_link 'Show'

      page.should have_content 'ITDC Slow Internet Connection'
      page.should have_content 'Low Bandwidth'
      page.should have_content 'Nico Catajoy'
      page.should have_content 'vnrcatajoy@gmail.com'
      page.should have_content 'Administration'
      page.should have_content 'Top Priority'
      page.should have_content '1-Critical'
      page.should have_content '3A'
      page.should have_content 'New'

    end
  end

  describe "PUT /issues" do
    it "edits an issue" do
      visit issues_path
      find("#issue_#{@issue.id}").click_link 'Edit'

      current_path.should == edit_issue_path(@issue)
      find_field('Title').value.should == 'ITDC Slow Internet Connection'
      find_field('Description').value.should == 'Low Bandwidth'
      find_field('User').value.should == '1'
      # find_field('Orignator Email').value.should == 'vnrcatajoy@gmail.com'
      find_field('Department').value.should == '1'
      find_field('Impact').value.should == '1'
      find_field('Status').value.should == '1'
      find_field('Type').value.should == '4'
      find_field('ISO Reference') == '5'

      fill_in 'Title', with: 'Internet connection is very slow'
      fill_in 'Impact', with: '2'
      fill_in 'Status', with: '2'

      click_button 'Update Issue'

      current_path.should == issues_path

      page.should have_content 'Internet connection is very slow'
      page.should have_content '2-Major'
      page.should have_content 'Investigating'

    end
  end

  describe "DELETE /issues" do
    it "deletes an issue" do
      visit issues_path
      
      find("#issue_#{@issue.id}").click_link 'Delete'
      page.should have_content 'Issue was successfuly deleted.'
      page.should have_no_content 'Internet connection is very slow'

    end
  end

end
