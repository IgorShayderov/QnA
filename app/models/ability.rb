# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can %i[update destroy], [Question, Answer], user_id: @user.id
    can :best, Answer, user_id: @user.id
    can %i[vote_for vote_against], [Question, Answer]
    cannot %i[vote_for vote_against], [Question, Answer], user_id: @user.id
    can :unvote, Vote, user_id: @user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :destroy, Link, linkable: { user_id: @user.id }
    can :destroy, Subscription, user_id: @user_id
  end
end
