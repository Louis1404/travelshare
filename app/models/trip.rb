class Trip < ApplicationRecord
  has_many :travellers, dependent: :destroy
end
