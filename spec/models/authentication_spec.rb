# frozen_string_literal: true

require_relative '../rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'validations' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :uid }
    it { is_expected.to validate_presence_of :user }
  end
end
