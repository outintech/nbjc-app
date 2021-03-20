FactoryBot.define do
    factory :random_anon_review, class: Review do
        anonymous {true} 
        vibe_check {rand(1..3)} 
        rating {rand(1..5)} 
        content {"Lorem ipsum dolor sit amet"}
        space_id {1} 
        user_id {1}
    end

    factory :random_review, class: Review do
        anonymous {false} 
        vibe_check {rand(1..3)} 
        rating {rand(1..5)} 
        content {"Lorem ipsum dolor sit amet"} 
        space_id {1}
        user_id {1}
    end

    factory :random_review_assign_space_user, class: Review do
        anonymous {false} 
        vibe_check {rand(1..3)} 
        rating {rand(1..5)} 
        content {"Lorem ipsum dolor sit amet"} 
    end

    factory :random_anon_review_assign_space_user, class: Review do
        anonymous {true} 
        vibe_check {rand(1..3)} 
        rating {rand(1..5)} 
        content {"Lorem ipsum dolor sit amet"}
    end
end