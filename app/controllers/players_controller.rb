class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin


  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
    @teams = Team.all
  end

  # GET /players/1/edit
  def edit
    @teams = Team.all
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)
    @player.live_score = 0
    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def clearscore
    @player = Player.find(params[:id])

    @player.live_score = 0.0
    @player.save

  end

  def update_individual
    @ids = params[:live_score]
    print("hello#{@ids}")
    @players = Player.update(params[:players], params[:players].values).reject { |p| p.errors.empty? }
    if @players.empty?
      flash[:notice] = "Products updated"
      redirect_to products_url
    else
      render :action => "edit_individual"
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    if @player.update(player_params)

      lps = LineupPlayer.where(player_id: @player.id)

      lps.each do |player|
        if Contest.find(Lineup.find(player.lineup_id).contest_id).paid_out == false
          calcTotalScore(Lineup.find(player.lineup_id))
        end
      end
      redirect_to players_url
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:id, :name, :team_id, :salary, :avgFP, :position, :live_score)
    end
end
