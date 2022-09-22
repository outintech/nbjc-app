require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#name' do
    let(:user) { create(:user) }

    it 'should allow a dash' do
      user.name = 'Ava-Marie'
      assert user.valid?
    end


    it 'should allow a period' do
      user.name = 'Errol Rutherford Jr.'
      assert user.valid?
    end

    it 'should allow a apostrophe' do
      user.name = "Kandis O'Connell"
      assert user.valid?
    end

  end


end

