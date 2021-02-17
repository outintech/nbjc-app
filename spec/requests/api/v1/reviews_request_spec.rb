require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
    login_user

    describe "GET reviews route" do
        let!(:spaces) {FactoryBot.create_list(:random_space, 20)}
        let!(:non_anon_reviews) {FactoryBot.create_list(:random_review, 12)}
        
        before do
            controller.stub(:authenticate_user! => true)
            get :index, params: { space_id: 1 }
        end

        it "gets all the reviews for a space" do
            expect(JSON.parse(response.body)['data'][0].size).to eq(12)
        end
    end

    describe "POST review and GET review routes" do
        space = Space.new(
            name: Faker::Company.name,
        )
        if space.valid?
            space.save
        end

        user = User.new(
            email: "fakereview@user.com",
            password: "qwertyFake",
            username: "fakereviewuser"
        )
        if user.valid?
            user.save
        end

        review_test = Review.new(
            anonymous: false, 
            vibe_check: rand(1..3), 
            rating: rand(1..5), 
            content: "Lorem ipsum dolor sit amet etc etc etc", 
            user_id: user.id,
            space_id: space.id
        )
        
        before do
            controller.stub(:authenticate_user! => true)
            post :create, params: { :review=> review_test }
        end
    
        it 'returns the review' do
          expect(JSON.parse(response.body).size).to eq(1)
        end
    
        it 'returns a created status' do
          expect(response).to have_http_status(:created)
        end
    
        it 'returns all the details for a space' do
          id = JSON.parse(response.body)['data']['review']['id']
          get :show, params: {id: id}
          p data = JSON.parse(response.body)['data']
        end
    end

    describe "Update a space's details" do

        before do
            space = Space.new(
            name: Faker::Company.name,
            )
            if space.valid?
                space.save
            end

            user = create(:review_user_one)

            @review = create(:random_review_assign_space_user, space_id: space.id, user_id: user.id)
        end
    
        it 'updates a review' do
          @new_content = "New lorem ipsum text"
          controller.stub(:authenticate_user! => true)
          put :update, params: { id: @review.id, review: { content: @new_content } }
    
          expect(response.status).to eq(202)
          expect(Review.find(@review.id).content).to eq(@new_content)
        end
      end
    
      describe "Delete a review" do

        before(:each) do

            space = Space.new(
            name: Faker::Company.name,
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
          
          controller.stub(:authenticate_user! => true)
          delete :destroy, params: {id: @review_one.id}
          expect(response.status).to eq(204)
    
          get :index, params: { space_id: @space_id }
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)['data'].size).to eq(1)
        end
      end

end
