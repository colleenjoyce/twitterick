require 'spec_helper'

describe PoemsController do
	describe "GET #index" do 
		it "renders the index template" do 
			get :index
			expect(response).to render_template("index")
		end
	end

	describe "POST #create" do 
		it "shows a list of twitter user handles"  
		
	end

end
