class Entry < ActiveRecord::Base
  belongs_to :krake
  validates :url, :format => URI::regexp(%w(http https)), unless: :url_empty?

  def url_empty?
    if self.url.nil? || self.url.empty?
      return true
    else
      return false
    end
  end
end
