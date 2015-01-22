# encoding: UTF-8
require 'spec_helper'

describe User, type: :model do
  context "before validations" do
    it "should trim @ from twitter username if present" do
      user = FactoryGirl.build(:user, twitter_username: '@dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryGirl.build(:user, twitter_username: '  @dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it "should not change twitter username if @ is not present" do
      user = FactoryGirl.build(:user, twitter_username: 'dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryGirl.build(:user, twitter_username: '  dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it "should remove state for non brazilians" do
      user = FactoryGirl.build(:user, country: "US", state: "Illinois")
      expect(user).to be_valid
      expect(user.state).to be_empty
    end
  end

  context "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }

    context "brazilians" do
      subject { FactoryGirl.build(:user, country: "BR") }
      it { should_not validate_presence_of :state }
    end

    it { should ensure_length_of(:username).is_at_least(3).is_at_most(30) }
    it { should ensure_length_of(:password).is_at_least(8).is_at_most(128) }
    it { should ensure_length_of(:email).is_at_least(6).is_at_most(100) }
    it { should ensure_length_of(:first_name).is_at_most(100) }
    it { should ensure_length_of(:last_name).is_at_most(100) }
    it { should ensure_length_of(:organization).is_at_most(100) }
    it { should ensure_length_of(:website_url).is_at_most(100) }

    it { should allow_value("dtsato").for(:username) }
    it { should allow_value("123").for(:username) }
    it { should allow_value("a b c").for(:username) }
    it { should allow_value("danilo.sato").for(:username) }
    it { should allow_value("dt-sato@dt_sato.com").for(:username) }
    it { should_not allow_value("dt$at0").for(:username) }
    it { should_not allow_value("<>/?").for(:username) }
    it { should_not allow_value(")(*&^%$@!").for(:username) }
    it { should_not allow_value("[=+]").for(:username) }

    it { should allow_value("user@domain.com.br").for(:email) }
    it { should allow_value("test_user.name@a.co.uk").for(:email) }
    it { should_not allow_value("a").for(:email) }
    it { should_not allow_value("a@").for(:email) }
    it { should_not allow_value("a@a").for(:email) }
    it { should_not allow_value("@12.com").for(:email) }

    context "uniqueness" do
      subject { FactoryGirl.create(:user, country: "BR") }

      it { should validate_uniqueness_of(:email).with_message(I18n.t("activerecord.errors.models.user.attributes.email.taken")) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_uniqueness_of(:username).case_insensitive }
    end

    it { should validate_confirmation_of :password }

    it "should validate that username doesn't change" do
      user = FactoryGirl.create(:user)
      user.username = 'new_username'
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include(I18n.t("errors.messages.constant"))
    end
  end

  it "should provide full name" do
    user = User.new(first_name: "Danilo", last_name: "Sato")
    expect(user.full_name).to eq("Danilo Sato")
  end

  it "should overide to_param with username" do
    user = FactoryGirl.create(:user, username: 'danilo.sato 1990@2')
    expect(user.to_param.ends_with?("-danilo-sato-1990-2")).to be true

    user.username = nil
    expect(user.to_param.ends_with?("-danilo-sato-1990-2")).to be false
  end

  it "should have 'pt' as default locale" do
    user = FactoryGirl.build(:user)
    expect(user.default_locale).to eq('pt')
  end
end
