module ControllerMacros
    def login_user
        token = ''
        before(:each) do 
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = FactoryBot.create(:user)
            token = user.generate_jwt
        end
        token
    end

end