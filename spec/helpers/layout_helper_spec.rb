# frozen_string_literal: true

require_relative '../rails_helper'

RSpec.describe LayoutHelper, type: :helper do
  describe '#title' do
    before { allow(self).to receive(:content_for).and_return(true) }

    it 'invokes content for title with string version of title' do
      a_title = []

      title(a_title, false)

      expect(self).to have_received(:content_for).with(:title, a_title.to_s)
    end

    it 'decides to show title or not based on second parameter' do
      title('title', false)

      expect(helper).not_to be_show_title
    end

    it 'defaults to show title' do
      title('title')

      expect(helper).to be_show_title
    end
  end
end
