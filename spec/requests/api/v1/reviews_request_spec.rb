require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
    login_user

    describe "GET reviews route" do
        let!(:spaces) {FactoryBot.create_list(:random_space, 20)}
        let!(:non_anon_reviews) {FactoryBot.create_list(:random_review, 12)}
        
        before do
            get :index, params: { space_id: 1 }
        end

        it "gets all the reviews for a space" do
            expect(JSON.parse(response.body)['data'][0].size).to eq(12)
        end
    end

    describe "POST review route" do
        @space = Space.new(
            name: Faker::Company.name,
        )
        if @space.valid?
            @space.save
        end

        @user = User.new(
            email: "fakereview@user.com",
            password: "qwertyFake",
            username: "fakereviewuser"
        )
        if @user.valid?
            @user.save
        end

        @review = Review.new(
            anonymous: false, 
            vibe_check: rand(1..3), 
            rating: rand(1..5), 
            content: "Lorem ipsum dolor sit amet etc etc etc", 
            user_id: @user.id,
            space_id: @space.id
        )

        before do
            post :create, params: {space_id: 42, review: @review}
        end

        it 'returns the review' do
            p response
        end
    end

end
