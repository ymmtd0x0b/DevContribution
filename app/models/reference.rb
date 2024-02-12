class Reference < ApplicationRecord
  belongs_to :issue
  belongs_to :pull_request
end
