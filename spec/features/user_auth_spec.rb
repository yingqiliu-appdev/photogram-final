require "rails_helper"

describe "/users" do
  it "has the usernames of multiple users", :points => 1 do
    first_user = User.new
    first_user.username = "alice_#{rand(100)}"
    first_user.email = "alice_#{rand(100)}@example.com"
    first_user.password = "password"
    first_user.save

    second_user = User.new
    second_user.username = "bob_#{rand(100)}"
    second_user.email = "bob_#{rand(100)}@example.com"
    second_user.password = "bob_#{rand(100)}"
    second_user.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/users"

    expect(page).to have_content(first_user.username)
    expect(page).to have_content(second_user.username)
  end
end

describe "/users/[USERNAME]" do
  it "has the username of the user", :points => 1 do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.email = "alice_#{rand(100)}@example.com"
    user.password = "password"
    user.save
    
    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}"

    expect(page).to have_content(user.username)
  end
end

describe "/users/[USERNAME]" do
  it "has the usernames of the user's pending follow requests", :points => 1 do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.email = "alice_#{rand(100)}@example.com"
    user.password = "password"
    user.save

    alice = User.new
    alice.username = "ALICE #{rand(99)}"
    alice.email = "ALICE #{rand(99)}@example.com"
    alice.password = "password"
    alice.save 

    bob = User.new
    bob.username = "bob #{rand(99)}"
    bob.email = "bob #{rand(99)}@example.com"
    bob.password = "password"
    bob.save

    carol = User.new
    carol.username = "carol #{rand(99)}"
    carol.email = "carol #{rand(99)}@example.com"
    carol.password = "password"
    carol.save

    alice_fr = FollowRequest.new
    alice_fr.sender_id = alice.id
    alice_fr.recipient_id = user.id
    alice_fr.status = "pending"
    alice_fr.save
    
    bob_fr = FollowRequest.new
    bob_fr.sender_id = bob.id
    bob_fr.recipient_id = user.id
    bob_fr.status = "pending"
    bob_fr.save
    
    carol_fr = FollowRequest.new
    carol_fr.sender_id = carol.id
    carol_fr.recipient_id = user.id
    carol_fr.status = "accepted"
    carol_fr.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}"

    expect(page).to have_content(alice.username)
    expect(page).to have_content(bob.username)
    expect(page).to_not have_content(carol.username)
  end
end

describe "/users/[USERNAME]" do
  it "has the photos posted by the user", :points => 1 do
    user = User.new
    user.username = "paul_bunyun"
    user.email = "paul_bunyun@example.com"
    user.password = "password"
    user.save

    other_user = User.new
    other_user.username = "codnot"
    other_user.email = "codnot@example.com"
    other_user.password = "password"
    other_user.save

    first_photo = Photo.new
    first_photo.owner_id = user.id
    first_photo.caption = "First caption #{rand(100)}"
    first_photo.image = "First caption #{rand(100)}"
    first_photo.save

    second_photo = Photo.new
    second_photo.owner_id = other_user.id
    second_photo.caption = "Second caption #{rand(100)}"
    second_photo.image = "Second caption #{rand(100)}"
    second_photo.save

    third_photo = Photo.new
    third_photo.owner_id = user.id
    third_photo.caption = "Third caption #{rand(100)}"
    third_photo.image = "Third caption #{rand(100)}"
    third_photo.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}"

    expect(page).to have_content(first_photo.caption)
    expect(page).to have_content(third_photo.caption)
    expect(page).to have_no_content(second_photo.caption)
  end
end

describe "/users/[USERNAME]/feed" do
  it "has the photos posted by the people the user is following", :points => 2 do
    user = User.new
    user.username = "believe_in_yourself"
    user.email = "believe_in_yourself@example.com"
    user.password = "password"
    user.save

    first_other_user = User.new
    first_other_user.username = "the_girl_reading_this_is_beautiful"
    first_other_user.email = "the_girl_reading_this_is_beautiful@example.com"
    first_other_user.password = "the_boy_reading_this_is_beautiful"
    first_other_user.save

    first_other_user_first_photo = Photo.new
    first_other_user_first_photo.owner_id = first_other_user.id
    first_other_user_first_photo.caption = "Some caption z"
    first_other_user_first_photo.image = "Some caption z"
    first_other_user_first_photo.save

    first_other_user_second_photo = Photo.new
    first_other_user_second_photo.owner_id = first_other_user.id
    first_other_user_second_photo.caption = "Some caption y"
    first_other_user_second_photo.image = "Some caption y"
    first_other_user_second_photo.save

    second_other_user = User.new
    second_other_user.username = "who_is_bernie_mac"
    second_other_user.email = "who_is_bernie_mac@example.com"
    second_other_user.password = "thenbpersionisbeautiful"
    second_other_user.save

    second_other_user_first_photo = Photo.new
    second_other_user_first_photo.owner_id = second_other_user.id
    second_other_user_first_photo.caption = "Some caption a"
    second_other_user_first_photo.image = "Some image a"
    second_other_user_first_photo.save
    
    second_other_user_second_photo = Photo.new
    second_other_user_second_photo.owner_id = second_other_user.id
    second_other_user_second_photo.caption = "Some caption b"
    second_other_user_second_photo.image = "Some caption b"
    second_other_user_second_photo.save

    third_other_user = User.new
    third_other_user.username = "jeporday"
    third_other_user.email = "jeporday@example.com"
    third_other_user.password = "jeporday"
    third_other_user.save

    third_other_user_first_photo = Photo.new
    third_other_user_first_photo.owner_id = third_other_user.id
    third_other_user_first_photo.caption = "Some caption c"
    third_other_user_first_photo.image = "Some image c"
    third_other_user_first_photo.save

    third_other_user_second_photo = Photo.new
    third_other_user_second_photo.owner_id = third_other_user.id
    third_other_user_second_photo.caption = "Some caption d"
    third_other_user_second_photo.image = "Some caption d"
    third_other_user_second_photo.save

    fourth_other_user = User.new
    fourth_other_user.username = "nocat"
    fourth_other_user.email = "nocat@example.com"
    fourth_other_user.password = "nocat"
    fourth_other_user.save

    fourth_other_user_first_photo = Photo.new
    fourth_other_user_first_photo.owner_id = fourth_other_user.id
    fourth_other_user_first_photo.caption = "Some caption e"
    fourth_other_user_first_photo.image = "Some image e"
    fourth_other_user_first_photo.save

    fourth_other_user_second_photo = Photo.new
    fourth_other_user_second_photo.owner_id = fourth_other_user.id
    fourth_other_user_second_photo.caption = "Some caption f"
    fourth_other_user_second_photo.image = "Some image f"
    fourth_other_user_second_photo.save

    first_follow_request = FollowRequest.new
    first_follow_request.sender_id = user.id
    first_follow_request.recipient_id = first_other_user.id
    first_follow_request.status = "rejected"
    first_follow_request.save

    second_follow_request = FollowRequest.new
    second_follow_request.sender_id = user.id
    second_follow_request.recipient_id = second_other_user.id
    second_follow_request.status = "accepted"
    second_follow_request.save

    third_follow_request = FollowRequest.new
    third_follow_request.sender_id = user.id
    third_follow_request.recipient_id = third_other_user.id
    third_follow_request.status = "pending"
    third_follow_request.save

    fourth_follow_request = FollowRequest.new
    fourth_follow_request.sender_id = user.id
    fourth_follow_request.recipient_id = fourth_other_user.id
    fourth_follow_request.status = "accepted"
    fourth_follow_request.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}/feed"

    expect(page).to have_content(second_other_user_first_photo.caption)
    expect(page).to have_content(second_other_user_second_photo.caption)
    expect(page).to have_content(fourth_other_user_first_photo.caption)
    expect(page).to have_content(fourth_other_user_second_photo.caption)

    expect(page).to have_no_content(first_other_user_first_photo.caption)
    expect(page).to have_no_content(third_other_user_first_photo.caption)
  end
end

describe "/users/[USERNAME]/liked_photos" do
  it "has the photos the user has liked", :points => 2 do
    user = User.new
    user.username = "you_can_do_this"
    user.email = "you_can_do_this@example.com"
    user.password = "password"
    user.save

    other_user = User.new
    other_user.username = "camel_case"
    other_user.email = "camel_case@example.com"
    other_user.password = "camel_case"
    other_user.save

    first_photo = Photo.new
    first_photo.owner_id = other_user.id
    first_photo.caption = "First caption"
    first_photo.image = "First caption"
    first_photo.save

    second_photo = Photo.new
    second_photo.owner_id = user.id
    second_photo.caption = "Second caption"
    second_photo.image = "Second caption"
    second_photo.save

    third_photo = Photo.new
    third_photo.owner_id = other_user.id
    third_photo.caption = "Third caption"
    third_photo.image = "Third caption"
    third_photo.save

    first_like = Like.new
    first_like.photo_id = first_photo.id
    first_like.fan_id = user.id
    first_like.save

    second_like = Like.new
    second_like.photo_id = second_photo.id
    second_like.fan_id = other_user.id
    second_like.save

    third_like = Like.new
    third_like.photo_id = third_photo.id
    third_like.fan_id = user.id
    third_like.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}/liked_photos"

    expect(page).to have_content(first_photo.caption)
    expect(page).to have_content(third_photo.caption)
    expect(page).to have_no_content(second_photo.caption)
  end
end

describe "/users/[USERNAME]/discover" do
  it "has the photos that are liked by the people the user is following", :points => 2 do
    user = User.new
    user.username = "jelani_is_the_best_ta"
    user.email = "jelani_is_the_best_ta@example.com"
    user.password = "password"
    user.save
    
    first_other_user = User.new
    first_other_user.username = "patrick_is_a_good_ta"
    first_other_user.email = "patrick_is_a_good_ta@example.com"
    first_other_user.password = "patrick_is_a_good_ta"
    first_other_user.save
    
    second_other_user = User.new
    second_other_user.username = "logan_is_a_ta"
    second_other_user.email = "logan_is_a_ta@example.com"
    second_other_user.password = "logan_is_a_ta"
    second_other_user.save
    
    third_other_user = User.new
    third_other_user.username = "give_me_free_cookies"
    third_other_user.email = "give_me_free_cookies@example.com"
    third_other_user.password = "give_me_free_cookies"
    third_other_user.save
    
    fourth_other_user = User.new
    fourth_other_user.username = "jelani_is_still_the_best_ta"
    fourth_other_user.email = "jelani_is_still_the_best_ta@example.com"
    fourth_other_user.password = "jelani_is_still_the_best_ta"
    fourth_other_user.save

    first_other_user_first_liked_photo = Photo.new
    first_other_user_first_liked_photo.owner_id = fourth_other_user.id
    first_other_user_first_liked_photo.caption = "Some caption #{1}"
    first_other_user_first_liked_photo.image = "Someimage #{1}"
    first_other_user_first_liked_photo.save

    first_other_user_first_like = Like.new
    first_other_user_first_like.fan_id = first_other_user.id
    first_other_user_first_like.photo_id = first_other_user_first_liked_photo.id
    first_other_user_first_like.save

    first_other_user_second_liked_photo = Photo.new
    first_other_user_second_liked_photo.owner_id = fourth_other_user.id
    first_other_user_second_liked_photo.caption = "Some caption 2"
    first_other_user_second_liked_photo.image = "Some caption 2"
    first_other_user_second_liked_photo.save

    first_other_user_first_like = Like.new
    first_other_user_first_like.fan_id = first_other_user.id
    first_other_user_first_like.photo_id = first_other_user_second_liked_photo.id
    first_other_user_first_like.save

    second_other_user_first_liked_photo = Photo.new
    second_other_user_first_liked_photo.owner_id = fourth_other_user.id
    second_other_user_first_liked_photo.caption = "Some caption 3"
    second_other_user_first_liked_photo.image = "Some caption 3"
    second_other_user_first_liked_photo.save

    second_other_user_first_like = Like.new
    second_other_user_first_like.fan_id = second_other_user.id
    second_other_user_first_like.photo_id = second_other_user_first_liked_photo.id
    second_other_user_first_like.save

    second_other_user_second_liked_photo = Photo.new
    second_other_user_second_liked_photo.owner_id = fourth_other_user.id
    second_other_user_second_liked_photo.caption = "Some caption 4"
    second_other_user_second_liked_photo.image = "Some caption 4"
    second_other_user_second_liked_photo.save

    second_other_user_first_like = Like.new
    second_other_user_first_like.fan_id = second_other_user.id
    second_other_user_first_like.photo_id = second_other_user_second_liked_photo.id
    second_other_user_first_like.save

    third_other_user_first_liked_photo = Photo.new
    third_other_user_first_liked_photo.owner_id = fourth_other_user.id
    third_other_user_first_liked_photo.caption = "Some caption 5"
    third_other_user_first_liked_photo.image = "Some image 5"
    third_other_user_first_liked_photo.save

    third_other_user_first_like = Like.new
    third_other_user_first_like.fan_id = third_other_user.id
    third_other_user_first_like.photo_id = third_other_user_first_liked_photo.id
    third_other_user_first_like.save

    third_other_user_second_liked_photo = Photo.new
    third_other_user_second_liked_photo.owner_id = fourth_other_user.id
    third_other_user_second_liked_photo.caption = "Some caption 6"
    third_other_user_second_liked_photo.image = "imagelink"
    third_other_user_second_liked_photo.save

    third_other_user_first_like = Like.new
    third_other_user_first_like.fan_id = third_other_user.id
    third_other_user_first_like.photo_id = third_other_user_second_liked_photo.id
    third_other_user_first_like.save

    fourth_other_user_first_liked_photo = Photo.new
    fourth_other_user_first_liked_photo.owner_id = fourth_other_user.id
    fourth_other_user_first_liked_photo.caption = "Some caption 7"
    fourth_other_user_first_liked_photo.image = "Some caption 7"
    fourth_other_user_first_liked_photo.save

    fourth_other_user_first_like = Like.new
    fourth_other_user_first_like.fan_id = fourth_other_user.id
    fourth_other_user_first_like.photo_id = fourth_other_user_first_liked_photo.id
    fourth_other_user_first_like.save

    fourth_other_user_second_liked_photo = Photo.new
    fourth_other_user_second_liked_photo.owner_id = fourth_other_user.id
    fourth_other_user_second_liked_photo.caption = "Some caption 8"
    fourth_other_user_second_liked_photo.image = "Somfiam 8"
    fourth_other_user_second_liked_photo.save

    fourth_other_user_first_like = Like.new
    fourth_other_user_first_like.fan_id = fourth_other_user.id
    fourth_other_user_first_like.photo_id = fourth_other_user_second_liked_photo.id
    fourth_other_user_first_like.save

    first_follow_request = FollowRequest.new
    first_follow_request.sender_id = user.id
    first_follow_request.recipient_id = first_other_user.id
    first_follow_request.status = "rejected"
    first_follow_request.save

    second_follow_request = FollowRequest.new
    second_follow_request.sender_id = user.id
    second_follow_request.recipient_id = second_other_user.id
    second_follow_request.status = "accepted"
    second_follow_request.save

    third_follow_request = FollowRequest.new
    third_follow_request.sender_id = user.id
    third_follow_request.recipient_id = third_other_user.id
    third_follow_request.status = "pending"
    third_follow_request.save

    fourth_follow_request = FollowRequest.new
    fourth_follow_request.sender_id = user.id
    fourth_follow_request.recipient_id = fourth_other_user.id
    fourth_follow_request.status = "accepted"
    fourth_follow_request.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
    
    visit "/users/#{user.username}/discover"

    expect(page).to have_content(second_other_user_first_liked_photo.caption)
    expect(page).to have_content(second_other_user_second_liked_photo.caption)
    expect(page).to have_content(fourth_other_user_first_liked_photo.caption)
    expect(page).to have_content(fourth_other_user_second_liked_photo.caption)

    expect(page).to have_no_content(first_other_user_first_liked_photo.caption)
    expect(page).to have_no_content(third_other_user_first_liked_photo.caption)
  end
end

describe "/users/[username] - Delete this photo button" do
  it "displays Delete this photo button when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"

    expect(page).to have_content(first_user.username)

    expect(page).to have_link("Delete this photo")
  end
end

describe "/photos/[ID] - Delete this photo button" do
  it "displays Delete this photo button when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"

    expect(page).to have_content(first_user.username)

    expect(page).to have_link("Delete this photo")
  end
end

describe "/photos/[ID] - Update photo form" do
  it "displays Update photo form when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"


    expect(page).to have_text("Update photo")
  end
end

describe "/photos/[ID] - Like Form" do
  it "automatically populates photo_id and fan_id with current photo and signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 0
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    old_likes_count = photo.likes_count
    visit "/photos/#{photo.id}"
    
    click_on "Like"

    expect(photo.likes.count).to be >= (old_likes_count + 1)
  end
end

describe "/photos/[ID] - Unlike link" do
  it "automatically associates like with signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 1
    photo.save

    like = Like.new
    like.fan_id = first_user.id
    like.photo_id = photo.id
    like.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    
    visit "/photos/#{photo.id}"
    old_likes_count = photo.likes_count

    # Should only display "Unlike" when the signed in user has liked the photo
    click_on "Unlike"

    expect(photo.likes.count).to eql(old_likes_count - 1)
  end
end

describe "/photos/[ID] — Add comment form" do
  it "automatically associates comment with signed in user and current photo", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.email = "alice@example.com"
    first_user.likes_count = 0
    first_user.comments_count = 0
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 0
    photo.comments_count = 0
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Email", with: first_user.email
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    test_comment = "Hey, what a nice app you're building!"

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    click_on "Add comment"

    added_comment = Comment.where({ :author_id => first_user.id, :photo_id => photo.id, :body => test_comment }).at(0)

    expect(added_comment).to_not be_nil
  end
end
