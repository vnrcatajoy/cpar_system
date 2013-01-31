require 'spec_helper'

describe "Issues" do
  before do
    #create an issue with fixed params
    @issue = Issue.create title: 'Slow Internet Connection', description: 'It sucks.'
  end

  describe "GET /issues" do
    it "displays all issues [title]" do
      visit issues_path
      page.should have_content 'Slow Internet Connection'

      save_and_open_page
    end
    
  end

end
