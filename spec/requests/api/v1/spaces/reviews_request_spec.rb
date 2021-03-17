require 'rails_helper'

RSpec.describe Api::V1::Spaces::ReviewsController, type: :controller do

    describe "GET reviews route" do
        before do
            space = Space.new(
            name: Faker::Company.name,
            )
            address = Address.new(
                address_1: "100 Main St",
                address_2: "",
                city: "Aurora",
                postal_code: "80015",
                country: "US",
                state: "CO",
                space: space
            )
            if space.valid?
                space.save
            end

            user = create(:review_user_two)
            @space_id = space.id
            @review_one = create(:random_review_assign_space_user, space_id: space.id, user_id: user.id)
            @review_two = create(:random_anon_review_assign_space_user, space_id: space.id, user_id: user.id)

            get :index, params: { space_id: @space_id }
        end

        it "gets all the reviews for a space" do
            expect(JSON.parse(response.body)['data'].size).to eq(2)
        end
    end

    describe "POST review and GET review routes" do
        before do

            space = Space.new(
            name: Faker::Company.name,
            )
            address = Address.new(
                address_1: "100 Main St",
                address_2: "",
                city: "Aurora",
                postal_code: "80015",
                country: "US",
                state: "CO",
                space: space
            )
            if space.valid?
                space.save
            end
            @space_id = space.id

            user = create(:create_review_user)
            @user_id = user.id
            @username = user.username
        
            controller.stub(:authenticate_request! => true)
            post :create, params: {review: {
                anonymous: false, 
                vibe_check: rand(1..3), 
                rating: rand(1..5), 
                content: "Lorem ipsum dolor sit amet etc etc etc", 
                user_id: @user_id,
                space_id: @space_id
                }
            }
        end
    
        it 'returns the review' do
          expect(JSON.parse(response.body).size).to eq(1)
        end
    
        it 'returns a created status' do
          expect(response).to have_http_status(:created)
        end
    
        it 'returns all the details for a space' do
          id = JSON.parse(response.body)['data']['review']['id']
          get :show, params: {id: id, space_id: @space_id}
          data = JSON.parse(response.body)['data']
          expect(data["space_id"]).to eq(@space_id)
          expect(data["content"]).to eq("Lorem ipsum dolor sit amet etc etc etc")
          expect(data["attributed_user"]).to eq(@username)
        end
    end

    describe "Update a space's details" do

        before do
            space = Space.new(
            name: Faker::Company.name,
            )
            address = Address.new(
                address_1: "100 Main St",
                address_2: "",
                city: "Aurora",
                postal_code: "80015",
                country: "US",
                state: "CO",
                space: space
            )
            if space.valid?
                space.save
            end
            
            @space_id = space.id

            user = create(:review_user_one)

            @review = create(:random_review_assign_space_user, space_id: space.id, user_id: user.id)
        end
    
        it 'updates a review' do
          @new_content = "New lorem ipsum text"
          controller.stub(:authenticate_request! => true)
          put :update, params: { space_id: @space_id, id: @review.id, review: { content: @new_content } }
    
          expect(response.status).to eq(302)
          expect(Review.find(@review.id).content).to eq(@new_content)
        end
    end
    
    describe "Delete a review" do

        before(:each) do

            space = Space.new(
            name: Faker::Company.name,
            )
            address = Address.new(
                address_1: "100 Main St",
                address_2: "",
                city: "Aurora",
                postal_code: "80015",
                country: "US",
                state: "CO",
                space: space
            )
            if space.valid?
                space.save
            end

            user = create(:review_user_two)
            
            @space_id = space.id
            @review_one = create(:random_review_assign_space_user, space_id: space.id, user_id: user.id)
            @review_two = create(:random_anon_review_assign_space_user, space_id: space.id, user_id: user.id)
        end
    
        it 'should delete the review' do
          get :index, params: { space_id: @space_id }
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)['data'].size).to eq(2)
          
          controller.stub(:authenticate_request! => true)
          delete :destroy, params: {space_id: @space_id, id: @review_one.id}
          expect(response.status).to eq(204)
    
          get :index, params: { space_id: @space_id }
          expect(response.status).to eq(200)
        end
    end

end
