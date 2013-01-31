require 'spec_helper'

describe "Issues" do
  before do
  	#create an issue with fixed params
    @issue = Issue.create title: 'Slow Internet Connection', description: 'It sucks.'
  end

  describe "GET /issues" do
    it "displays all issues with title and their description" do
      visit issues_path
      
      page.should have_content 'Slow Internet Connection'
      page.should have_content 'It sucks.'

    end

    it "navigates to add issue page" do
   	  visit issues_path
      click_link 'Report New Issue'

      current_path.should == new_issue_path

      page.should have_content 'Title'
      page.should have_content 'Issue Description'
      page.should have_content 'Originator'
      page.should have_content 'Originator Email'
      page.should have_content 'Group in Charge'
      page.should have_content 'Type'
      page.should have_content 'Impact'
      page.should have_content 'ISO Reference ID'
      #add cause and action plan

    end
  end

end
