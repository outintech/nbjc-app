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

    describe "POST review route" do
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

        review_fake = Review.new(
            anonymous: false, 
            vibe_check: rand(1..3), 
            rating: rand(1..5), 
            content: "Lorem ipsum dolor sit amet etc etc etc", 
            user_id: user.id,
            space_id: space.id
        )

        before do
            controller.stub(:authenticate_user! => true)
            post :create, params: {review: review_fake}
        end

        it 'returns the review' do
            p response
        end
    end

    describe "SHOW review route" do
        space = Space.new(
            name: Faker::Company.name,
        )
        if space.valid?
            space.save
        end

        user = User.new(
            email: "fakereview2@user.com",
            password: "qwertyFake",
            username: "fakereview2user"
        )
        if user.valid?
            user.save
        end

        review = Review.new(
            anonymous: false, 
            vibe_check: rand(1..3), 
            rating: rand(1..5), 
            content: "Lorem ipsum dolor sit amet etc etc etc", 
            user_id: user.id,
            space_id: space.id
        )
        review.save

        before do
            controller.stub(:authenticate_user! => true)
            get :show, params: {review_id: review.id}
        end

        it 'returns the review' do
            p response
        end
    end

end
