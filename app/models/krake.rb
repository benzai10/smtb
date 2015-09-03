class Krake < ActiveRecord::Base
  has_many :entries

  def self.search(k0, k1, k2, k3, k4, k5)
    k0 ? self.where('description = ?', "#{k0}") : self.all
  end

  def approval_score
    approved_count = self.entries.approved.count
    disagreed_count = self.entries.disagreed.count
    100 * (approved_count + 1) / (approved_count + 1 + disagreed_count)
  end

  def self.related_keywords(keyword_ids)
    r1 = self.where("keyword_ids ILIKE '%+#{keyword_ids[0]}+%'").pluck(:keyword_ids)
    r1 = r1.join.split("+").map{|i|i.to_i}.uniq
    r1 -= [0]
    if !keyword_ids[1].nil?
      r2 = self.where("keyword_ids ILIKE '%+#{keyword_ids[1]}+%'").pluck(:keyword_ids)
      r2 = r2.join.split("+").map{|i|i.to_i}.uniq
      r2 -= [0]
    else
      return r1
    end
    if !keyword_ids[2].nil?
      r3 = self.where("keyword_ids ILIKE '%+#{keyword_ids[2]}+%'").pluck(:keyword_ids)
      r3 = r3.join.split("+").map{|i|i.to_i}.uniq
      r3 -= [0]
    else
      related_keywords = r1 & r2
      return related_keywords
    end
    if !keyword_ids[3].nil?
      r4 = self.where("keyword_ids ILIKE '%+#{keyword_ids[3]}+%'").pluck(:keyword_ids)
      r4 = r4.join.split("+").map{|i|i.to_i}.uniq
      r4 -= [0]
    else
      related_keywords = r1 & r2 & r3
      return related_keywords
    end
    if !keyword_ids[4].nil?
      r5 = self.where("keyword_ids ILIKE '%+#{keyword_ids[4]}+%'").pluck(:keyword_ids)
      r5 = r5.join.split("+").map{|i|i.to_i}.uniq
      r5 -= [0]
      related_keywords = r1 & r2 & r3 & r4 & r5
      return related_keywords
    else
      related_keywords = r1 & r2 & r3 & r4
      return related_keywords
    end
  end
end
