class KrakesController < ApplicationController
  def index
    @keyword_ids = []
    if !params[:k].nil?
      if !params[:k0].nil?
        @current_keywords = [params[:k0].downcase]
      else
        @current_keywords = [nil]
      end
      @current_keywords.concat(params[:k].split("+"))
    else
      @current_keywords = [params[:k0], nil, nil, nil, nil]
    end
    @current_keywords.each do |k|
      keyword = Keyword.find_by_description(k)
      if !keyword.nil?
        @keyword_ids << keyword.id
      else
        @keyword_ids << 0
      end
    end
    @existing_krake = Krake.find_by_keyword_ids(@keyword_ids.sort!.to_s)
    if !@existing_krake.nil?
      @entry = @existing_krake.entries.first
    end
    @keywords = Keyword.all
  end
end