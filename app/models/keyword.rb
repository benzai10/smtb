class Keyword < ActiveRecord::Base
  has_many :kships
  has_many :rel_keywords, through: :kships
  has_many :inverse_kships, class_name: "Kship", foreign_key: "rel_keyword_id"
  has_many :inverse_rel_keywords, through: :inverse_kships, source: :keyword

  def self.search(k1, k2, k3, k4, k5)
    if k1
      self.where('description = ?', "#{k1}")
    else
      self.all
    end
  end
end
