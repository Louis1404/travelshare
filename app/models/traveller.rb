class Traveller < ApplicationRecord
  belongs_to :profile
  belongs_to :trip
  has_many :ways, dependent: :destroy
end
