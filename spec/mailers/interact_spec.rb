require "spec_helper"

describe Interact do
  describe 'reveal_handle_user' do
    let(:user){ mock_model User, fname: 'Ivy', email: 'ifu@oberlin.edu'}
    let(:admin){ mock_model User, fname: 'Leo', email: 'larlesienne@outlook.com', admin: True}
  end
  describe 'send_e' do
    let(:user){ mock_model User, fname: 'Ivy', lname: 'Fu', email: 'ifu@oberlin.edu'}
    let(:mail){Interact.send_e("Ho","Hello world", user)}

    it 'sends an email' do
      expect { ActionMailer::Base.deliveries.count }
        .to change.by(1)
    end

    it 'renders the subject' do
      expect(mail.subject.to eql("Ho: Hello world Fu")
    end
  end
end

