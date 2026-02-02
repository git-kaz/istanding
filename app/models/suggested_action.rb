class SuggestedAction < ApplicationRecord
  belongs_to :sitting_session
  belongs_to :exercise
end
