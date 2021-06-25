class TemplatesController < ApplicationController
  before_action :set_member

  def show
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      flash[:notice] = "Templates successfully saved"
      redirect_to member_path
    else
      flash[:error] = "Couldn't save templates"
      render 'new'
    end
  end

  def post_templates
    uploaded_file = params[:images]
    begin
      file = File.open(uploaded_file)
      file = file.read
      begin
        images = JSON.parse(file)
        images = images["images"]
        data = { "#{@member.identity}" => ["#{@member.node}", images] }.to_json

        response = HTTParty.post("http://127.0.0.1:5000/predict", body: data)
        $data = JSON.parse(response.body)

        redirect_to accepted_path
      rescue Exception
        flash[:error] = "Can not parse uploaded file!"
        render :show
      end

    rescue Exception
      flash[:error] = "Can not read uploaded file!"
      render :show
    end

  end

  def destroy
    @template.destroy
    flash[:notice] = @member.identity.to_s + "'s templates deleted"
    redirect_to members_path
  end

  private

  def template_params
    params.permit(member: @member)
  end

  def set_member
    @member = Member.find(params[:member_id])
  end

end
