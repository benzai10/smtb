class Entry < ActiveRecord::Base
  # Entry types
  # 1: Best-entry
  # 2: Approval entry
  # 3: Individual entry
  # 4: Entry request

  belongs_to :krake
  validates :description, presence: true
  validates :url, :format => URI::regexp(%w(http https)), unless: :url_empty?

  def url_empty?
    if self.url.nil? || self.url.empty?
      return true
    else
      return false
    end
  end
end
