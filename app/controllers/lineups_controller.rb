class LineupsController < ApplicationController
  before_action :set_lineup, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /lineups
  # GET /lineups.json
  def index
    redirect_to contests_path
    @lineups = Lineup.all
  end

  # GET /lineups/1
  # GET /lineups/1.json
  def show
  end

  # GET /lineups/new
  def new
    @lineup = Lineup.new

    @contest = Contest.find(params[:contest_id])

    @lineup.contest_id = params[:contest_id]

    @slate = Slate.find(@contest.slate_id)

    if @contest.curr_size == @contest.max_size
      redirect_to contests_path
    end

    if @slate.start_time < Time.now
      redirect_to contests_path
    end


    @games = Game.where(slate_id: @contest.slate_id)
    teams = Array.new
    players = Array.new
    tops = Array.new
    mids = Array.new
    supports = Array.new
    adcs = Array.new
    junglers = Array.new

    @games.each do |game|
      teams.append(Team.find(game.team_1))
      teams.append(Team.find(game.team_2))

      players += (Player.where(team_id: game.team_1).all)
      players += (Player.where(team_id: game.team_2).all)

    end

    @players = players.uniq
    @teams = teams.uniq

    players.each do |player|
      if player.position == "top"
        tops.append(player)
      elsif player.position == "mid"
        mids.append(player)
      elsif player.position == "adc"
        adcs.append(player)
      elsif player.position == "support"
        supports.append(player)
      elsif player.position == "jungle"
        junglers.append(player)
                           
      end
    end

    @tops = tops
    @mids = mids
    @adcs = adcs
    @supports = supports
    @junglers = junglers


  end

  # GET /lineups/1/edit
  def edit
    if @lineup.user_id != current_user.id
      redirect_to contests_path
    end
    @contest = Contest.find(params[:contest_id])
    if @contest.start_time < Time.now
      redirect_to contests_path
    end

    @games = Game.where(slate_id: @contest.slate_id)
    teams = Array.new
    players = Array.new
    tops = Array.new
    mids = Array.new
    supports = Array.new
    adcs = Array.new
    junglers = Array.new

    @games.each do |game|
      teams.append(Team.find(game.team_1))
      teams.append(Team.find(game.team_2))

      players += (Player.where(team_id: game.team_1).all)
      players += (Player.where(team_id: game.team_2).all)

    end

    @players = players.uniq
    @teams = teams.uniq

    players.each do |player|
      if player.position == "top"
        tops.append(player)
      elsif player.position == "mid"
        mids.append(player)
      elsif player.position == "adc"
        adcs.append(player)
      elsif player.position == "support"
        supports.append(player)
      elsif player.position == "jungle"
        junglers.append(player)
                           
      end
    end

    @tops = tops
    @mids = mids
    @adcs = adcs
    @supports = supports
    @junglers = junglers
  end

  # POST /lineups
  # POST /lineups.json
  def create
    @lineup = Lineup.new(lineup_params)
    @contest = Contest.find(params[:contest_id])
    @slate = Slate.find(@contest.slate_id)

    if current_user.balance < @contest.fee
      redirect_to contests_path
      return
    end

    if @contest.curr_size == @contest.max_size
      redirect_to contests_path
      return
    end

    if @slate.start_time < Time.now
      redirect_to contests_path
      return
    end

    '''
      contest.slate_id
      players each
      player on team in slate 
    '''
    ### BEGIN CHECKING PLAYER VALIDITY ###

    games = Array.new
    games += Game.where(slate_id: @contest.slate_id).all
    game_ids = Array.new
    team_ids = Array.new
    players = Array.new
    totSalary = 0


    games.each do |game|
      team1 = Team.find(game.team_1)
      team2 = Team.find(game.team_2)
      team_ids.append(team1.id)
      team_ids.append(team2.id)
    end

    ### BEGING CHECK FOR DUPLICATE PLAYERS ###
    top = Player.find(@lineup.top)
    mid = Player.find(@lineup.mid)
    adc = Player.find(@lineup.adc)
    support = Player.find(@lineup.support)
    jungler = Player.find(@lineup.jungler)
    flex_1 = Player.find(@lineup.flex_1)
    flex_2 = Player.find(@lineup.flex_2)
    flex_3 = Player.find(@lineup.flex_3)

    players += [top.id, mid.id, adc.id, support.id, jungler.id, flex_1.id, flex_2.id, flex_3.id]
    players = players.uniq

    if players.length != 8
      # DUPLICATE PLAYER EXISTS #
      redirect_to contests_path
      return
    end

    players.each do |player|
      totSalary += Player.find(player).salary
    end

    if totSalary > 60000
      redirect_to contests_path
      return
    end

    # ENSURE PLAYERS ARE PLAYING IN GAME IN SLATE #
    if !team_ids.include? top.team_id
      redirect_to contests_path
    elsif !team_ids.include? mid.team_id
      redirect_to contests_path
    elsif !team_ids.include? adc.team_id
      redirect_to contests_path
    elsif !team_ids.include? support.team_id
      redirect_to contests_path
    elsif !team_ids.include? jungler.team_id
      redirect_to contests_path
    elsif !team_ids.include? flex_1.team_id
      redirect_to contests_path
    elsif !team_ids.include? flex_2.team_id
      redirect_to contests_path
    elsif !team_ids.include? flex_3.team_id
      redirect_to contests_path
    end

    @lineup.contest_id = params[:contest_id]
    @lineup.user_id = current_user.id

    if @lineup.save 
      current_user.balance -= @contest.fee
      bal = Balance.where(user_id: current_user.id)
      bal -= @contest.fee
      bal.save
      current_user.save
    end

    @contest.curr_size += 1
    @contest.save

    #can before_save go here?

    respond_to do |format|
      if @lineup.save 
        format.html { redirect_to @lineup, notice: 'Lineup was successfully created.' }
        format.json { render :show, status: :created, location: @lineup }
      else
        format.html { render :new }
        format.json { render json: @lineup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lineups/1
  # PATCH/PUT /lineups/1.json
  def update
    if @lineup.user_id != current_user.id
      redirect_to contests_path
    end
    respond_to do |format|
      if @lineup.update(lineup_params)
        format.html { redirect_to @lineup, notice: 'Lineup was successfully updated.' }
        format.json { render :show, status: :ok, location: @lineup }
      else
        format.html { render :edit }
        format.json { render json: @lineup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lineups/1
  # DELETE /lineups/1.json
  def destroy
    @contest = Contest.find(@lineup.contest_id)
    @contest.curr_size -= 1
    @contest.save

    @lineup.destroy
    respond_to do |format|
      format.html { redirect_to lineups_url, notice: 'Lineup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lineup
      @lineup = Lineup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lineup_params
      params.require(:lineup).permit(:top, :mid, :adc, :support, :jungler, :flex_1, :flex_2, :flex_3, :user_id, :contest_id)
    end
end
