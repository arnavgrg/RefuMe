class Match < ApplicationRecord
  # since matches involve two users
  # a match belongs to both a mantor and a mentee
  #belongs_to :mentor, class_name: "User"
  #belongs_to :mentee, class_name: "User"
  #validates  :mentor_id, presence: true
  #validates  :mentee_id, presence: true
end
