require "spec_helper"

describe Interact do
  describe 'reveal_handle_user' do
    let(:user){ mock_model User, fname: 'Ivy', lname: 'Fu', email: 'ifu@oberlin.edu'}
    let(:admin){ mock_model User, fname: 'Leo', lname: 'Fu', email: 'larlesienne@outlook.com', admin: true}
    let(:handle){ mock_model Handle, username: 'Blacksheep'}
    let(:mail){Interact.reveal_handle_user(user, admin, handle).deliver}
    it 'renders the receiver email' do
      (mail.to).should eq([user.email])
    end

    it "renders the subject" do
      mail.subject.should eq("OPrestissimo Commenter Nickname Revealed")
    end

    it "has everything in it" do
      mail.body.include?('Ivy').should be_true
    end
      
  end

#mail_cart is too complicated to test with rspec so I use mailcatcher to see it works.""
  describe "mail_cart" do
    let(:email){"vzhu@oberlin.edu"}
    let(:cart){ stub_model Cart, courses: 'History'}
    let(:sender) { mock_model User, fname: 'Ivy', lname: 'Fu', email: 'ifu@oberlin.edu'}
    let(:requestip) {"12345678"}
  end

  describe 'send_e' do
    let(:user){ mock_model User, fname: 'Ivy', lname: 'Fu', email: 'ifu@oberlin.edu'}
    let(:mail){Interact.send_e("Ho","Hello world", user)}

    it 'sends an email' do
      expect{Interact.send_e("Ho","Hello world", user).deliver}
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'renders the subject' do
      mail.subject.should eql("Ho: Ivy Fu")
    end

  end
end

