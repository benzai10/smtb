class Entry < ActiveRecord::Base
  # Entry types
  # 1: Best-entry
  # 2: Approval entry
  # 3: Individual entry
  # 4: Entry request

  belongs_to :krake
  validates :description, presence: true
  validates :url, :format => URI::regexp(%w(http https)), unless: :url_empty?

  scope :best,         -> { where(entry_type: 1).last }
  scope :approved,     -> { where(entry_type: 2) }
  scope :disagreed,    -> { where(entry_type: 3) }
  scope :requested,    -> { where(entry_type: 4) }
  scope :user_created, -> { where(entry_type: [1, 3]) }
  scope :non_best,     -> { where(entry_type: [2, 3]) }
  
  def url_empty?
    self.url.nil? || self.url.empty? ? true : false
  end
end
