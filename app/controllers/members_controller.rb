class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :authenticate, :enroll, :unenroll]
  before_action :count, only: [:show, :new, :edit, :index, :accepted]
  before_action :restriction, only: [:accepted, :rejected]
  before_action :set_data, except: [:accepted, :rejected]
  before_action :logged_in_user, only: [:show, :index]
  require 'httparty'
  require 'json'
  require 'base64'
  $data = {}

  def new
    @member = Member.new
  end

  def create
    @member = current_user.members.build(member_params)
    if @member.valid?
      @member.save
      flash[:notice] = @member.identity.to_s + " added"
      redirect_to @member
    else
      flash.now[:error] = @member.errors.full_messages[0]
      render :new
    end
  end

  def edit
  end

  def update
    if @member.valid?
      @member.update(member_params)
      flash[:notice] = @member.identity.to_s + " updated"
      redirect_to(member_path(@member))
    else
      flash.now[:error] = @member.errors.full_messages[0]
      render :edit
    end
  end

  def destroy
    @member.destroy
    flash[:notice] = @member.identity.to_s + " deleted"
    redirect_to members_path
  end

  def index
    @members = Member.all
  end

  def show
  end

  def enroll
    uploaded_file = params[:signals]
    begin
      file = File.open(uploaded_file)
      content = file.read
      file.close

      data = { "data" => ["#{@member.identity}" , content] }.to_json
      response = HTTParty.post("http://127.0.0.1:5000/enroll", body: data)
      $data = JSON.parse(response.body)

      if $data.key?("success")
        flash[:notice] = $data["success"]

        @template = @member.templates.build(template_parameters)
        if @template.valid?
          @template.save
          flash[:notice] = "Template saved to database"
          redirect_to @member
        end

      elsif $data.key?("error")
        flash[:error] = $data["error"]
        redirect_to @member
      end
    rescue Exception
      flash[:error] = "API server down or can not parse file!"
      redirect_to @member
    end
  end

  def unenroll
    #begin
      data = { "data" => "#{@member.identity}" }.to_json
      response = HTTParty.post("http://127.0.0.1:5000/unenroll", body: data)
      $data = JSON.parse(response.body)

      if $data.key?("success")
        flash[:notice] = $data["success"]

        @template = Template.where(member_id: @member.id).first
        if @template.destroy
          flash[:notice] = "Template removed from database"
          redirect_to @member
        end

      elsif $data.key?("error")
        flash[:error] = $data["error"]
        redirect_to @member
      end
    #rescue Exception
    # flash[:error] = "API server down or can not parse file!"
    # redirect_to @member
    #end
  end

  def verify
    uploaded_file = params[:signals]
    begin
      file = File.open(uploaded_file)
      content = file.read
      file.close

      data = { "data" => content }.to_json
      response = HTTParty.post("http://127.0.0.1:5000/verify", body: data)
      $data = JSON.parse(response.body)

      if $data.key?("success")
        $data = $data["success"]
        redirect_to accepted_path
      elsif $data.key?("failure")
        $data = $data["error"]
        redirect_to rejected_path
      elsif $data.key?("error")
        flash[:error] = $data["error"]
        redirect_to root_path
      end
    rescue Exception
      flash[:error] = "API server down or can not parse file!"
      redirect_to root_path
    end
  end

  def validates
    uploaded_file = params[:signals]
    begin
      file = File.open(uploaded_file)
      content = file.read
      file.close
      begin
        images = JSON.parse(content)
        images = images["images"]
        data = { "#{@member.identity}" => ["#{@member.node}", images] }.to_json

        response = HTTParty.post("http://127.0.0.1:5000/validate", body: data)
        $data = JSON.parse(response.body)

        if $data.key?("success")
          $data = $data["success"]
          redirect_to accepted_path
        elsif $data.key?("failure")
          $data = $data["failure"]
          redirect_to rejected_path
        elsif $data.key?("error")
          flash[:error] = $data["error"]
          render :show
        end
      rescue Exception
        flash[:error] = "API server down or can not parse uploaded file!"
        render :show
      end

    rescue Exception
      flash[:error] = "Can not read uploaded file!"
      render :show
    end
  end

  def authenticate
    @member = Member.where(identity: params[:identity]).first
    if not @member.blank?
      @member = Member.find_by(identity: params[:identity])
      redirect_to member_path(@member)
    else
      flash[:error] = params[:identity] + " does not exist"
      redirect_to root_path
    end
  end

  def accepted
    @member = Member.find_by(identity: $data)
  end

  def rejected
    @identity = $data
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:identity, :node, :name, :gender, :age, user: current_user)
  end

  def template_parameters
    params.permit(member: @member)
  end

  def count
    @count = Member.count
  end

  def restriction
    if $data == {}
      flash[:error] = "Unauthorised access!"
      redirect_to root_path
    end
  end

  def set_data
    $data = {}
  end

end