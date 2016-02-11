class SlatesController < ApplicationController
  before_action :set_slate, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin

  # GET /slates
  # GET /slates.json
  def index
    @slates = Slate.all
  end

  # GET /slates/1
  # GET /slates/1.json
  def show
    @streams = StreamLink.where(slate_id: @slate.id)
  end

  # GET /slates/new
  def new
    @slate = Slate.new
  end

  # GET /slates/1/edit
  def edit
  end


  def scores
    @contest = Contest.find(params[:id])
    @games = Game.where(slate_id: @contest.slate_id)
    teams = Array.new
    players = Array.new

    @games.each do |game|
      teams.append(Team.find(game.team_1))
      teams.append(Team.find(game.team_2))

      players += (Player.where(team_id: game.team_1).all)
      players += (Player.where(team_id: game.team_2).all)

    end

    @players = players.uniq
    @teams = teams.uniq
  end

  # POST /slates
  # POST /slates.json
  def create
    @slate = Slate.new(slate_params)

    respond_to do |format|
      if @slate.save
        format.html { redirect_to @slate, notice: 'Slate was successfully created.' }
        format.json { render :show, status: :created, location: @slate }
      else
        format.html { render :new }
        format.json { render json: @slate.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_all
    params['player'].keys.each do |id|
      @player = Player.find(id.to_i)
      @player.update_attributes(params['player'][id])
    end
    redirect_to(players_url)
end

  # PATCH/PUT /slates/1
  # PATCH/PUT /slates/1.json
  def update
    respond_to do |format|
      if @slate.update(slate_params)
        format.html { redirect_to @slate, notice: 'Slate was successfully updated.' }
        format.json { render :show, status: :ok, location: @slate }
      else
        format.html { render :edit }
        format.json { render json: @slate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slates/1
  # DELETE /slates/1.json
  def destroy
    @slate.destroy
    respond_to do |format|
      format.html { redirect_to slates_url, notice: 'Slate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def closeSlate

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slate
      @slate = Slate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slate_params
      params.require(:slate).permit(:start_time, :name)
    end

    def startSlate
      @contests = Contest.where(slate_id: :id).all

      @contests.each do |contest|
        if contest.max_size != contest.curr_size
          '''
          refund
          '''
        end
      end
      
    end

end