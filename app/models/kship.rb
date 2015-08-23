class Kship < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :rel_keyword, class_name: "keyword"
end
