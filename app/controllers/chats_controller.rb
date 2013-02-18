class ChatsController < ApplicationController
  #list of before filterrs
  before_filter :authenticate, :setup
  respond_to :html, :js

  #displays a certain chat
  def show
    @chat = Chat.find(params[:id])
  end

  #makes a new chat based on parameters passed in params
  def new
    @chat = Chat.new(params[:chat])
  end

  #blank, but can be filled with functions for chat (such as search)
  def index
    @chats = Chat.where("turf_id = ? and id > ?", params[:turf_id], params[:after])
    respond_with(@chats)
  end

  #creates a new chat based on current user, current turf, and params content values
  #stores in in the database, flashing a success or failure if it worked
  def create
    @user = current_user
    @turf = Turf.find_by_id(params[:chat][:turf_id_value])
    @chat = @turf.chats.build(:content => params[:chat][:content])
    @chat.user = current_user

    if @chat.save
      respond_with(@chat)
      flash[:success] = "Chat created!"
    else
      flash[:error] = "Chat not created :("
    end
  end

  #can be used to delete chats down the line
  def destroy
  end


  protected
    #setup for getting the current turf and user if available, called as a before filter
    def setup      
      @user = current_user
    end
end
