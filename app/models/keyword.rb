class Keyword < ActiveRecord::Base
  has_many :kships
  has_many :rel_keywords, through: :kships
  has_many :inverse_kships, class_name: "Kship", foreign_key: "rel_keyword_id"
  has_many :inverse_rel_keywords, through: :inverse_kships, source: :keyword
end
