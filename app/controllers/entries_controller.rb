class EntriesController < ApplicationController
  def create
    keyword_ids = []
    current_keywords = params[:entry][:current_keywords].split
    k0 = current_keywords.first
    # Create keyword if it doesn't exist yet
    if Keyword.find_by_description(k0).nil?
      Keyword.create!(description: k0.downcase)
    end
    keyword_ids << Keyword.find_by_description(k0).id
    current_keywords.shift
    k = ""
    current_keywords.each do |c|
      # Create keyword if it doesn't exist
      if Keyword.find_by_description(c).nil?
        Keyword.create!(description: c.downcase)
        keyword_ids << Keyword.find_by_description(c).id
      else
        if c.length > 0
          keyword_ids << Keyword.find_by_description(c).id
        end
      end
      k += c
      k += "+"
    end
    # Create Krake
    keyword_ids.sort!
    krake = Krake.create(keyword_ids: keyword_ids.to_s)
    @entry = krake.entries.new
    @entry.description = params[:entry][:description]
    @entry.url = params[:entry][:url]
    @entry.save
    redirect_to krakes_path(k0: k0, k: k)
  end
end