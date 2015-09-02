require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
      other_user.follow!(@user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    it "should destroy relationships between followed_users and followers" do
      @user.destroy
      @user.relationships.present?.should be_false
      @user.reverse_relationships.present?.should be_false

      expect(other_user.followers).not_to include(@user)
      expect(other_user.followed_users).not_to include(@user)
    end
  end
end
