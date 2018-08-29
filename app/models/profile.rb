class Profile < ApplicationRecord
  belongs_to :user
  has_many :travellers
  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?
end
