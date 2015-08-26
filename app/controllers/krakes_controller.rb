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
    @keyword_ids.sort!
    @existing_krake = Krake.find_by_keyword_ids("+" + @keyword_ids.join("+") + "+")
    @related_keywords = Krake.related_keywords(@keyword_ids) - @keyword_ids
    if !@existing_krake.nil?
      @best_entry = @existing_krake.entries.find_by_entry_type(1)
      approved_count = @existing_krake.entries.where(entry_type: 2).count
      disagreed_count = @existing_krake.entries.where(entry_type: 3).count
      @approval_score = 100 * (approved_count + 1) / (approved_count + 1 + disagreed_count)
      if user_signed_in?
        @approved_entry = @existing_krake.entries.where(entry_type: 2, user_id: current_user.id).last
        @own_entry = @existing_krake.entries.where(entry_type: 3, user_id: current_user.id).last
      end
      @request_entries = @existing_krake.entries.where(entry_type: 4)
      @own_request_entry = @request_entries.find_by_user_id(current_user.id)
    end
    if user_signed_in?
      @user_created_entries = Entry.where(user_id: current_user.id, entry_type: [1, 3])
      @user_approved_entries = Entry.where(user_id: current_user.id, entry_type: 2)
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