FactoryGirl.define do
  sequence(:last_name) { |n| "Name#{n}" }

  factory :user do
    first_name 'User'
    last_name
    username { |a| "#{a.first_name}.#{a.last_name}".downcase }
    email { |a| "#{a.username.parameterize}@example.com" }
    password 'abigsecret'
    password_confirmation 'abigsecret'
    phone '(11) 3322-1234'
    country 'BR'
    state 'SP'
    city 'São Paulo'
    organization 'ThoughtWorks'
    website_url 'hugocorbucci.com'
    bio 'Some text about me...'
  end

  factory :simple_user, class: User do
    first_name 'User'
    last_name
    username { |a| "#{a.first_name}.#{a.last_name}".downcase }
    email { |a| "#{a.username.parameterize}@example.com" }
    password 'abigsecret'
    password_confirmation 'abigsecret'
  end
end
