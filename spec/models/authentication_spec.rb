#encoding: UTF-8
require_relative '../rails_helper'

describe Authentication do
  context 'validations' do
    it { should belong_to(:user) }

    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :user }
  end
end
