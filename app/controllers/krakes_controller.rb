class KrakesController < ApplicationController
  def index
    @current_keywords = current_keywords(params[:k0], params[:k])
    @keyword_ids = current_keyword_ids
    #@current_keywords.each do |k|
      #keyword = Keyword.find_by_description(k)
      #if !keyword.nil?
        #@keyword_ids << keyword.id
      #else
        #@keyword_ids << 0
      #end
    #end
    #@keyword_ids.sort!
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
        @request_entries = @existing_krake.entries.where(entry_type: 4)
        @own_request_entry = @request_entries.find_by_user_id(current_user.id)
      end
      @request_entries = @existing_krake.entries.where(entry_type: 4)
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
    current_keywords = params[:keywords]
    k0 = current_keywords.first
    current_keywords.shift
    k = current_keywords
    if k.count > 0
      k = k.join("+")
    else
      k = ""
    end
    redirect_to krakes_path(k0: k0, k: k)
  end

  def current_keywords(param0, other_params)
    if !other_params.nil?
      if !param0.nil?
        current_keywords = [param0.downcase]
      else
        current_keywords = [nil]
      end
      current_keywords.concat(other_params.split("+"))
    else
      current_keywords = [param0, nil, nil, nil, nil]
    end
    current_keywords = []
    current_keywords
  end  


  def current_keyword_ids 
    @keyword_ids = []
    @current_keywords.each do |k|
      keyword = Keyword.find_by_description(k)
      if !keyword.nil?
        @keyword_ids << keyword.id
      else
        @keyword_ids << 0
      end
    end
    @keyword_ids.sort!
  end
end
