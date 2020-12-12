class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reviews

  has_many :user_roles
  has_many :roles, :through => :user_roles

  def admin?
    roles.where("roles.name = 'admin'").present?
  end

  def researcher?
    roles.where("roles.name = 'researcher").present?
  end
end
