class Krake < ActiveRecord::Base
  has_many :entries

  def self.search(k0, k1, k2, k3, k4, k5)
    if k0
      self.where('description = ?', "#{k0}")
    else
      self.all
    end
  end

end
