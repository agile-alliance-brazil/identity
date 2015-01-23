#encoding: UTF-8
require_relative '../rails_helper'

describe LayoutHelper, type: :helper do
  context '#title' do
    it 'should invoke content for title with string version of title' do
      a_title = []
      expect(self).to receive(:content_for).with(:title, a_title.to_s).and_return(true)

      title(a_title, false)
    end
    it 'should decide to show title or not based on second parameter' do
      expect(self).to receive(:content_for).and_return(true)
      title('title', false)

      expect(helper.show_title?).to be_falsey
    end
    it 'should default to show title' do
      expect(self).to receive(:content_for).and_return(true)
      title('title')

      expect(helper.show_title?).to be_truthy
    end
  end
end