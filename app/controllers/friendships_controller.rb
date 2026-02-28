class FriendshipsController < ApplicationController
  before_action :set_user
  before_action :set_friendship, only: %i[ update destroy ]

  def new
      @friendship = Friendship.new
      if params[:query].present?
        existing_friend_ids = Current.user.friend_records.pluck(:user_id, :friend_id).flatten.uniq
        @results = User.where.not(id: existing_friend_ids)
                       .where("email_address ILIKE ?", "%#{params[:query]}%")
                       .limit(10)

        print @results
      end
  end

  def create
    @friendship = Current.user.friendships.new(friend_id: friendship_params[:friend_id], status: "pending")
    if @friendship.save
      redirect_to new_user_friendship_path(@user), notice: "Friend request sent!"
    else
      redirect_to new_user_friendship_path(@user), alert: "Could not send friend request."
    end
  end

  def update
    if @friendship.update(friendship_params)
       redirect_to root_path, notice: "Friend request updated."
     else
       redirect_to root_path, alert: "Could not update friend request."
     end
  end

  def destroy
    @friendship.destroy
    redirect_to root_path, alert: "Friend removed."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.expect(friendship: [ :friend_id, :status ])
  end

end
