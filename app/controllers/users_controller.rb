class UsersController::RegistrationController < Devise::RegistrationController
	def edit 
		super do |resource|
			@c = "Colleen"
		end
	end 
end