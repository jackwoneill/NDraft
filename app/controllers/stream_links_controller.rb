class StreamLinksController < ApplicationController
  before_action :set_stream_link, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin, except: [:index]

  # GET /stream_links
  # GET /stream_links.json
  def index
    cons = Array.new
    slates = Array.new

    lines = Lineup.where(user_id: current_user.id)

    lines.each do |line|
      c = Contest.find(line.contest_id)
      if !c.paid_out
        cons.append(c)
        slates.append(Slate.find(c.slate_id))
      end
    end

    @slates = slates.uniq
    @contests = cons.uniq

  end

  # GET /stream_links/1
  # GET /stream_links/1.json
  def show
  end

  # GET /stream_links/new
  def new
    @stream_link = Stream_Link.new
    @slate_id = params[:slate_id]
  end

  # GET /stream_links/1/edit
  def edit
  end

  # POST /stream_links
  # POST /stream_links.json
  def create
    @stream_link = Stream_Link.new(stream_link_params)

    respond_to do |format|
      if @stream_link.save
        format.html { redirect_to @stream_link, notice: 'Stream link was successfully created.' }
        format.json { render :show, status: :created, location: @stream_link }
      else
        format.html { render :new }
        format.json { render json: @stream_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stream_links/1
  # PATCH/PUT /stream_links/1.json
  def update
    respond_to do |format|
      if @stream_link.update(stream_link_params)
        format.html { redirect_to @stream_link, notice: 'Stream link was successfully updated.' }
        format.json { render :show, status: :ok, location: @stream_link }
      else
        format.html { render :edit }
        format.json { render json: @stream_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stream_links/1
  # DELETE /stream_links/1.json
  def destroy
    @stream_link.destroy
    respond_to do |format|
      format.html { redirect_to stream_links_url, notice: 'Stream link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream_link
      @stream_link = Stream_Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stream_link_params
      params.require(:stream_link).permit(:slate_id, :url)
    end
end
