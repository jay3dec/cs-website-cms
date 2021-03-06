require 'will_paginate/array'

class MembersController < ApplicationController

  def login_managed_by
    logiMember.login_type 'jeffdonthemic'
  end    

  def community
    @community_tick = true
    @stats = Platform.stats
    @open_challenges = Challenge.open
    @featured_challenge =  Challenge.find @stats['featured_challenge_id']
    @leaderboard = Platform.leaderboard(current_access_token, :category => nil, :limit => 3)
    @press_feed_items = CloudspokesFeed.where(:entry_type => 'press').order('created_at desc').limit(3)
    @post_feed_items = CloudspokesFeed.where(:entry_type => 'posts').order('created_at desc').limit(3)    
  end   

  def leaderboard
    @leaderboard_tick = true
    @this_month = Platform.leaderboard(current_access_token, :period => 'month', :category => params[:category] || nil, :limit => 1000)
    @this_year = Platform.leaderboard(current_access_token, :period => 'year', :category => params[:category] || nil, :limit => 1000)
    @all_time = Platform.leaderboard(current_access_token, :category => params[:category] || nil, :limit => 1000)

    @this_month = @this_month.paginate(:page => params[:page_this_month] || 1, :per_page => 15) 
    @this_year = @this_year.paginate(:page => params[:page_this_year] || 1, :per_page => 15) 
    @all_time = @all_time.paginate(:page => params[:page_all_time] || 1, :per_page => 15) 
  end

  def forums
    @forums_tick = true
  end  
  
  # note that we provide our own search service so that we have greater control
  # over the results; e.g. caching, endpoint configuration, result format, etc.
  def search
    @members = Member.search params[:keyword]
    render json: @members, :callback => params[:callback]
  end

  def challenges
  end

  def payments
  end

  def recommendations
  end

  def create_recommendations
  end

  def index
    @members = Member.all
    render :json => @members
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @members }
    # end
  end

  def show
    @member = Member.find(params[:id], { fields: 'id,name,profile_pic' })
  end

  def update
  end
end
