class Member < ApplicationRecord
  belongs_to :user
  has_many   :templates

  validates_presence_of :user_id

  validates :identity,
            presence: { message: "can't be empty"},
            format: {with: /^[0-9]*$/,
                     multiline: true,
                     message: "is of incorrect format "},
            uniqueness: { message: "is already taken"},
            on: [:create, :update]

  validates :node,
            presence: { message: "can't be empty"},
            format: {with: /^[0-9]*$/,
                     multiline: true,
                     message: "is of incorrect format "},
            on: [:create, :update]
end
