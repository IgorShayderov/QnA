# frozen_string_literal: true

class RewardsController < ApplicationController
  def index
    authorize! :index, Reward
    @rewards = current_user.rewards
  end
end
