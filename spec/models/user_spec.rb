# frozen_string_literal: true

require_relative '../rails_helper'

RSpec.describe User, type: :model do
  describe 'builders' do
    let(:user) { FactoryBot.build(:user) }
    let(:auth_params) do
      {
        provider: 'provider_id',
        uid: 'uid',
        info: {
          name: user.full_name,
          email: user.email
        }
      }
    end

    describe 'from omniauth' do
      it 'finds user by authentication from auth object' do
        user.save
        user.authentications.create(auth_params.reject { |k, _v| k == :info })

        omni_user = described_class.from_omniauth(auth_params)
        expect(omni_user).to eq(user)
      end

      it 'attaches new authentication from auth object' do
        user.save

        omni_user = described_class.from_omniauth(auth_params)

        expect(omni_user).to eq(user)
        expect(user.authentications).to have(1).item
        expect(user.authentications.first.provider).to eq(
          auth_params[:provider]
        )
        expect(user.authentications.first.uid).to eq(auth_params[:uid])
      end

      it 'builds from auth object' do
        omni_user = described_class.from_omniauth(auth_params)

        expect(omni_user.id).not_to be_nil
        expect(omni_user.first_name).to eq(user.first_name)
        expect(omni_user.last_name).to eq(user.last_name)
        expect(omni_user.email).to eq(user.email)
        expect(omni_user.username).to eq(user.email)
        expect(omni_user.authentications).to have(1).item
        expect(omni_user.authentications.first.provider).to eq(
          auth_params[:provider]
        )
        expect(omni_user.authentications.first.uid).to eq(auth_params[:uid])
      end
    end

    describe 'from auth info hash' do
      it 'builds from info hash' do
        auth_user = described_class.from_auth_info(auth_params[:info])

        expect(auth_user.id).to be_nil
        expect(auth_user.first_name).to eq(user.first_name)
        expect(auth_user.last_name).to eq(user.last_name)
        expect(auth_user.email).to eq(user.email)
        expect(auth_user.username).to eq(user.email)
        expect(auth_user.authentications).to be_empty
      end

      it 'builds empty user without info' do
        auth_user = described_class.from_auth_info(nil)

        expect(auth_user.id).to be_nil
        expect(auth_user.first_name).to be_nil
        expect(auth_user.last_name).to be_nil
        expect(auth_user.username).to be_nil
        expect(auth_user.email).to be_nil
        expect(auth_user.authentications).to be_empty
      end

      it 'changes given user based on params' do
        other_user = described_class.new
        auth_user = described_class.from_auth_info(
          auth_params[:info],
          other_user
        )

        expect(auth_user).to equal(other_user)
        expect(auth_user.first_name).to eq(user.first_name)
        expect(auth_user.last_name).to eq(user.last_name)
        expect(auth_user.email).to eq(user.email)
        expect(auth_user.username).to eq(user.email)
      end

      it 'maps nickname to twitter_username' do
        auth_user = described_class.from_auth_info(
          auth_params[:info].merge(nickname: 'hugocorbucci')
        )

        expect(auth_user.twitter_username).to eq('hugocorbucci')
        expect(auth_user.last_name).to eq(user.last_name)
        expect(auth_user.email).to eq(user.email)
        expect(auth_user.username).to eq(user.email)
      end
    end

    describe 'with session' do
      it 'recovers data from session' do
        auth_user = described_class.new_with_session(
          {},
          User::SESSION_DATA_KEY => auth_params
        )

        expect(auth_user.first_name).to eq(user.first_name)
        expect(auth_user.last_name).to eq(user.last_name)
        expect(auth_user.email).to eq(user.email)
        expect(auth_user.username).to eq(user.email)
      end

      it 'uses default if nothing is in the session' do
        auth_user = described_class.new_with_session({}, {})

        expect(auth_user.first_name).to be_nil
        expect(auth_user.last_name).to be_nil
        expect(auth_user.email).to be_nil
        expect(auth_user.username).to be_nil
      end

      it 'uses params if provided' do
        auth_user = described_class.new_with_session({ first_name: 'Hugo' }, {})

        expect(auth_user.first_name).to eq('Hugo')
      end

      it 'provides preference to params if conflicting data in session' do
        auth_user = described_class.new_with_session(
          { first_name: 'Hugo' },
          info: { first_name: 'Danilo' }
        )

        expect(auth_user.first_name).to eq('Hugo')
      end
    end
  end

  describe 'before validations' do
    it 'trims @ from twitter username if present' do
      user = FactoryBot.build(:user, twitter_username: '@dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryBot.build(:user, twitter_username: '  @dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it 'does not change twitter username if @ is not present' do
      user = FactoryBot.build(:user, twitter_username: 'dtsato')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')

      user = FactoryBot.build(:user, twitter_username: '  dtsato  ')
      expect(user).to be_valid
      expect(user.twitter_username).to eq('dtsato')
    end

    it 'removes state for non brazilians' do
      user = FactoryBot.build(:user, country: 'US', state: 'Illinois')
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

  describe 'validations' do
    subject(:user) { FactoryBot.build(:user) }

    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }

    describe 'brazilians' do
      subject { FactoryBot.build(:user, country: 'BR') }

      it { is_expected.not_to validate_presence_of :state }
    end

    it do
      expect(user).to validate_length_of(:username)
        .is_at_least(3).is_at_most(30)
    end

    it do
      expect(user).to validate_length_of(:password)
        .is_at_least(8).is_at_most(128)
    end

    it do
      expect(user).to validate_length_of(:email)
        .is_at_least(6).is_at_most(100)
    end

    it { is_expected.to validate_length_of(:first_name).is_at_most(100) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(100) }
    it { is_expected.to validate_length_of(:organization).is_at_most(100) }
    it { is_expected.to validate_length_of(:website_url).is_at_most(100) }

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

    describe 'uniqueness' do
      subject(:user) { FactoryBot.create(:user, country: 'BR') }

      it do
        expect(user).to(
          validate_uniqueness_of(:email)
            .case_insensitive
            .with_message(I18n.t('errors.messages.taken'))
        )
      end

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end

    it { is_expected.to validate_confirmation_of :password }
  end

  describe 'associations' do
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
  end

  it 'provides full name' do
    user = described_class.new(first_name: 'Danilo', last_name: 'Sato')
    expect(user.full_name).to eq('Danilo Sato')
  end

  it 'overides to_param with username' do
    user = FactoryBot.create(:user, username: 'danilo.sato 1990@2')
    expect(user.to_param.ends_with?('-danilo-sato-1990-2')).to be true

    user.username = nil
    expect(user.to_param.ends_with?('-danilo-sato-1990-2')).to be false
  end

  it 'has "pt-BR" as default locale' do
    user = FactoryBot.build(:user)
    expect(user.default_locale).to eq('pt-BR')
  end
end
