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
      @best_entry = @existing_krake.entries.find_by_entry_type(1)
      @approved_entry = @existing_krake.entries.where(entry_type: 2, user_id: current_user.id).last
      @own_entry = @existing_krake.entries.where(entry_type: 3, user_id: current_user.id).last
    end
  end

  def add_approval
    @krake = Krake.find(params[:id])
    current_best_entry = @krake.entries.where(entry_type: 1).last
    @krake.entries.create!(description: current_best_entry.description,
                           url: current_best_entry.url,
                           entry_type: 2,
                           user_id: current_user.id)
    redirect_to :root
  end
end