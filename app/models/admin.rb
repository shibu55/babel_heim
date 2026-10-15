class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable は付けない。付けると /admins/sign_up から誰でも管理者になれる。
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
