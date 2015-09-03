class KrakesController < ApplicationController
  def index
    @current_keywords = current_keywords(params[:k0], params[:k])
    @keyword_ids = current_keyword_ids
    @existing_krake = Krake.find_by_keyword_ids("+" + @keyword_ids.join("+") + "+")
    @related_keywords = Krake.related_keywords(@keyword_ids) - @keyword_ids
    if !@existing_krake.nil?
      @best_entry = @existing_krake.entries.find_by_entry_type(1)
      @approval_score = @existing_krake.approval_score
      @request_entries   = @existing_krake.entries.requested
      if user_signed_in?
        @approved_entry  = @existing_krake.entries.approved.where(user_id: current_user.id).last
        @own_entry       = @existing_krake.entries.disagreed.where(user_id: current_user.id).last
        @own_request_entry = @request_entries.find_by_user_id(current_user.id)
      end
    end
    if user_signed_in?
      @user_created_entries  = Entry.user_created.where(user_id: current_user.id)
      @user_approved_entries = Entry.approved.where(user_id: current_user.id)
    end
  end

  def add_approval
    @krake = Krake.find(params[:id])
    current_best_entry = @krake.entries.best
    @krake.entries.create!(description: current_best_entry.description,
                           url: current_best_entry.url,
                           entry_type: 2,
                           user_id: current_user.id)
    current_keywords = params[:keywords]
    k0 = current_keywords.first
    current_keywords.shift
    k = current_keywords
    k.count > 0 ? k = k.join("+") : k = ""
    redirect_to krakes_path(k0: k0, k: k)
  end

  def current_keywords(param0, other_params)
    if !other_params.nil?
      param0.nil? ? current_keywords = [nil] : current_keywords = [param0.downcase]
      current_keywords.concat(other_params.split("+"))
    else
      current_keywords = [param0, nil, nil, nil, nil]
    end
  end  

  def current_keyword_ids 
    @keyword_ids = []
    @current_keywords.each do |k|
      keyword = Keyword.find_by_description(k)
      keyword.nil? ? @keyword_ids << 0 : @keyword_ids << keyword.id
    end
    @keyword_ids.sort!
  end
end
