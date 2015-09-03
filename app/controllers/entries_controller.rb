class EntriesController < ApplicationController
  def create
    keyword_ids = []
    current_keywords = params[:entry][:current_keywords].split
    k0 = current_keywords.first
    if params[:entry][:disapproval] == "true"
      krake = Krake.find(params[:entry][:krake_id].to_i)
      new_entry = krake.entries.new
      new_entry.user_id = current_user.id
      new_entry.description = params[:entry][:description]
      new_entry.url = params[:entry][:url]
      new_entry.entry_type = 3
      if new_entry.save
        current_keywords.shift
        k = current_keywords
        k.count > 0 ? k = k.join("+") : k = ""
        approved_entry = krake.entries.where(entry_type: 2,
                                             user_id: current_user.id).last
        if !approved_entry.nil?
          approved_entry.destroy
        end
        redirect_to krakes_path(k0: k0, k: k)
        return
      else
        flash[:error] = new_entry.errors.full_messages
        redirect_to krakes_path(k0: k0,
                                k: k, 
                                description: params[:entry][:description], 
                                url: params[:entry][:url])
      end
    else
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
      Krake.transaction do
        begin
          krake = Krake.find_by_keyword_ids("+" + keyword_ids.join("+") + "+")
          if krake.nil?
            krake = Krake.create(keyword_ids: "+" + keyword_ids.join("+") + "+")
          end
          @entry = krake.entries.new
          @entry.user_id = current_user.id
          if params[:commit].first(7) == "REQUEST"
            @entry.description = "request"
            @entry.url = ""
            @entry.entry_type = 4
            flash[:notice] = "Your request was saved."
          else
            @entry.description = params[:entry][:description]
            @entry.url = params[:entry][:url]
            @entry.entry_type = 1
          end
          @entry.save!
          redirect_to krakes_path(k0: k0, k: k)
          return
        rescue
          flash[:error] = @entry.errors.full_messages
          redirect_to krakes_path(k0: k0, k: k,
                                  description: params[:entry][:description],
                                  url: params[:entry][:url])
        end
        raise ActiveRecord::Rollback
        redirect_to :back
      end
    end
  end

  def update
    current_keywords = params[:entry][:current_keywords].split
    k0 = current_keywords.first
    current_keywords.shift
    k = current_keywords
    k.count > 0 ? k = k.join("+") : k = ""
    @entry = Entry.find(params[:id])
    @entry.description = params[:entry][:description]
    @entry.url = params[:entry][:url]
    if @entry.save
      redirect_to krakes_path(k0: k0, k: k)
    else
      flash[:error] = @entry.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    if !params[:k0].nil? || !params[:k].nil?
      current_keywords = params[:k].split
      k = current_keywords
      k.count > 0 ? k = k.join("+") : k = ""
      @entry = Entry.find(params[:id])
      @entry.destroy
      redirect_to krakes_path(k0: params[:k0], k: k)
    else
      @entry = Entry.find(params[:id])
      @entry.destroy
      redirect_to :root
    end
  end
end
