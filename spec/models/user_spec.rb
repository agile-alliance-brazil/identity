# encoding: UTF-8
require_relative '../rails_helper'

describe User, type: :model do
  context 'builders' do
    let(:user) {FactoryGirl.build(:user)}
    let(:auth_params) {
      {
        provider: 'provider_id',
        uid: 'uid',
        info: {
          name: user.full_name,
          email: user.email
        }
      }
    }
    it 'should find user by authentication from auth object' do
      user.save
      user.authentications.create(auth_params.reject{|k,v| k == :info})

      omni_user = User.from_omniauth(auth_params)
      expect(omni_user).to eq(user)
    end
    it 'should attach new authentication from auth object' do
      user.save

      omni_user = User.from_omniauth(auth_params)

      expect(omni_user).to eq(user)
      expect(user.authentications).to have(1).item
      expect(user.authentications.first.provider).to eq(auth_params[:provider])
      expect(user.authentications.first.uid).to eq(auth_params[:uid])
    end
    it 'should build from auth object' do
      omni_user = User.from_omniauth(auth_params)

      expect(omni_user.id).to_not be_nil
      expect(omni_user.authentications).to have(1).item
      expect(omni_user.authentications.first.provider).to eq(auth_params[:provider])
      expect(omni_user.authentications.first.uid).to eq(auth_params[:uid])
    end
    it 'should build from info hash' do
      auth_user = User.from_auth_info(auth_params[:info])

      expect(auth_user.id).to be_nil
      expect(auth_user.email).to eq(auth_params[:info][:email])
      expect(auth_user.authentications).to be_empty
    end
    it 'should build empty user without info' do
      auth_user = User.from_auth_info(nil)

      expect(auth_user.id).to be_nil
      expect(auth_user.email).to be_nil
      expect(auth_user.authentications).to be_empty
    end
  end

  context 'before validations' do
    it 'should trim @ from twitter username if present' do
      user = FactoryGirl.build(:user, twitter_username: '@dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryGirl.build(:user, twitter_username: '  @dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it 'should not change twitter username if @ is not present' do
      user = FactoryGirl.build(:user, twitter_username: 'dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryGirl.build(:user, twitter_username: '  dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it 'should remove state for non brazilians' do
      user = FactoryGirl.build(:user, country: 'US', state: 'Illinois')
      expect(user).to be_valid
      expect(user.state).to be_blank
    end

    it { is_expected.to normalize_attribute(:first_name) }
    it { is_expected.to normalize_attribute(:last_name) }
    it { is_expected.to normalize_attribute(:username) }
    it { is_expected.to normalize_attribute(:email) }
    it { is_expected.to normalize_attribute(:phone) }
    it { is_expected.to normalize_attribute(:state) }
    it { is_expected.to normalize_attribute(:city) }
    it { is_expected.to normalize_attribute(:organization) }
    it { is_expected.to normalize_attribute(:website_url) }
    it { is_expected.to normalize_attribute(:bio) }
    it { is_expected.to normalize_attribute(:country) }
    it { is_expected.to normalize_attribute(:twitter_username) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }

    context 'brazilians' do
      subject { FactoryGirl.build(:user, country: 'BR') }
      it { is_expected.not_to validate_presence_of :state }
    end

    it { is_expected.to ensure_length_of(:username).is_at_least(3).is_at_most(30) }
    it { is_expected.to ensure_length_of(:password).is_at_least(8).is_at_most(128) }
    it { is_expected.to ensure_length_of(:email).is_at_least(6).is_at_most(100) }
    it { is_expected.to ensure_length_of(:first_name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:last_name).is_at_most(100) }
    it { is_expected.to ensure_length_of(:organization).is_at_most(100) }
    it { is_expected.to ensure_length_of(:website_url).is_at_most(100) }

    it { is_expected.to allow_value('dtsato').for(:username) }
    it { is_expected.to allow_value('123').for(:username) }
    it { is_expected.to allow_value('a b c').for(:username) }
    it { is_expected.to allow_value('danilo.sato').for(:username) }
    it { is_expected.to allow_value('dt-sato@dt_sato.com').for(:username) }
    it { is_expected.to allow_value('dt+sato@dt_sato.com').for(:username) }
    it { is_expected.not_to allow_value('dt$at0').for(:username) }
    it { is_expected.not_to allow_value('<>/?').for(:username) }
    it { is_expected.not_to allow_value(')(*&^%$@!').for(:username) }
    it { is_expected.not_to allow_value('[=+]').for(:username) }

    it { is_expected.to allow_value('user@domain.com.br').for(:email) }
    it { is_expected.to allow_value('test_user.name@a.co.uk').for(:email) }
    it { is_expected.to allow_value('test_user+name@a.co.uk').for(:email) }
    it { is_expected.not_to allow_value('a').for(:email) }
    it { is_expected.not_to allow_value('a@').for(:email) }
    it { is_expected.not_to allow_value('a@a').for(:email) }
    it { is_expected.not_to allow_value('@12.com').for(:email) }

    context 'uniqueness' do
      subject { FactoryGirl.create(:user, country: 'BR') }

      it { is_expected.to validate_uniqueness_of(:email).with_message(I18n.t('activerecord.errors.models.user.attributes.email.taken')) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end

    it { is_expected.to validate_confirmation_of :password }

    it 'should validate that username does not change' do
      user = FactoryGirl.create(:user)
      user.username = 'new_username'
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include(I18n.t('errors.messages.constant'))
    end
  end

  context 'associations' do
    it { is_expected.to have_many(:authentications).dependent(:destroy)}
  end

  it 'should provide full name' do
    user = User.new(first_name: 'Danilo', last_name: 'Sato')
    expect(user.full_name).to eq('Danilo Sato')
  end

  it 'should overide to_param with username' do
    user = FactoryGirl.create(:user, username: 'danilo.sato 1990@2')
    expect(user.to_param.ends_with?('-danilo-sato-1990-2')).to be true

    user.username = nil
    expect(user.to_param.ends_with?('-danilo-sato-1990-2')).to be false
  end

  it 'should have "pt" as default locale' do
    user = FactoryGirl.build(:user)
    expect(user.default_locale).to eq('pt')
  end
end
