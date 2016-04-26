class LineupPlayersController < ApplicationController
  before_action :set_lineup_player, only: [:show, :edit, :update, :destroy]

  # GET /lineup_players
  # GET /lineup_players.json
  def index
    @lineup_players = LineupPlayer.all
  end

  # GET /lineup_players/1
  # GET /lineup_players/1.json
  def show
  end

  # GET /lineup_players/new
  def new
    @lineup_player = LineupPlayer.new
  end

  # GET /lineup_players/1/edit
  def edit
  end

  # POST /lineup_players
  # POST /lineup_players.json
  def create
    @lineup_player = LineupPlayer.new(lineup_player_params)

    respond_to do |format|
      if @lineup_player.save
        format.html { redirect_to @lineup_player, notice: 'Lineup player was successfully created.' }
        format.json { render :show, status: :created, location: @lineup_player }
      else
        format.html { render :new }
        format.json { render json: @lineup_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lineup_players/1
  # PATCH/PUT /lineup_players/1.json
  def update
    respond_to do |format|
      if @lineup_player.update(lineup_player_params)
        format.html { redirect_to @lineup_player, notice: 'Lineup player was successfully updated.' }
        format.json { render :show, status: :ok, location: @lineup_player }
      else
        format.html { render :edit }
        format.json { render json: @lineup_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lineup_players/1
  # DELETE /lineup_players/1.json
  def destroy
    @lineup_player.destroy
    respond_to do |format|
      format.html { redirect_to lineup_players_url, notice: 'Lineup player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lineup_player
      @lineup_player = LineupPlayer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lineup_player_params
      params.require(:lineup_player).permit(:lineup_id, :player_id)
    end
end
