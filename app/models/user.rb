class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :players
  has_many :games, through: :players


  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
       self.authentication_token = generate_authentication_token
    end
  end

  def as_json(opts={})
    super(:only => [:email, :authentication_token, :experience, :id])
  end

  def update_experience
    @user = User.find[params]
  end

 private
 def generate_authentication_token
   loop do
     token = Devise.friendly_token
     break token unless User.where(authentication_token: token).first
   end
 end

end
