class UsersController < ActiveRecord::Base

  def as_json(opts={})
    super(:only => [:id, :email])
  end

end
