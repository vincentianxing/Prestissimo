require 'spec_helper'

describe SyllabusController do

  describe "GET 'upload_syllabus'" do
    it "returns http success" do
      get 'upload_syllabus'
      response.should be_success
    end
  end

end
