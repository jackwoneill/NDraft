class LineupsController < ApplicationController
  before_action :set_lineup, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /lineups
  # GET /lineups.json
  def index
    redirect_to contests_path and return
    #@lineups = Lineup.all
  end

  # GET /lineups/1
  # GET /lineups/1.json
  def show
    redirect_to contests_path and return
  end

  # GET /lineups/new
  def new

    @lineup = Lineup.new

    @contest = Contest.find(params[:contest_id])

    @lineup.contest_id = params[:contest_id] 
    @lineup.gametype = @contest.game

    @slate = Slate.find(@contest.slate_id)


    ### BEGIN GAMETYPE ###
    @gametype = Gametype.find(@contest.game)
    @positions = Position.where(gametype_id: @gametype.id)
    @num_total_positions = 0

    @players_hash = Hash.new()

    @positions.each do |p|
      @num_total_positions += p.num_allowed
      @players_hash["position_#{p.pos_num}"] = "#{p.num_allowed}"
    end

    gon.players_hash = @players_hash
    gon.num_total_positions = @num_total_positions
    gon.num_dif_positions = @positions.count
    gon.num_flex = @gametype.num_flex
    gon.action = 1

    ##### END GAMETYPE ###
    if @contest.curr_size == @contest.max_size
      redirect_to contests_path and return
    end

    if @slate.start_time < Time.now
      redirect_to contests_path and return
    end

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

  # GET /lineups/1/edit
  def edit
    if @lineup.user_id != current_user.id
      redirect_to contests_path
    end
    @contest = Contest.find(@lineup.contest_id)
    if @contest.start_time < Time.now
      redirect_to contests_path
    end

    @lineup.gametype = @contest.game

    @slate = Slate.find(@contest.slate_id)

    ### BEGIN GAMETYPE ###
    @gametype = Gametype.find(@contest.game)
    @positions = Position.where(gametype_id: @gametype.id)
    @num_total_positions = 0

    @players_hash = Hash.new()

    @positions.each do |p|
      @num_total_positions += p.num_allowed
      @players_hash["position_#{p.pos_num}"] = "#{p.num_allowed}"
    end

    gon.players_hash = @players_hash
    gon.num_total_positions = @num_total_positions
    gon.num_dif_positions = @positions.count
    gon.num_flex = @gametype.num_flex
    gon.action = 2
    gon.lid = @lineup.id

    ##### END GAMETYPE ###

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

  # POST /lineups
  # POST /lineups.json
  def create
    @lineup = Lineup.new()
    @lineup.contest_id = params[:contest_id]
    @lineup.user_id = current_user.id
    @contest = Contest.find(params[:contest_id])
    @lineup.gametype = @contest.game

    respond_to do |format|

      if @lineup.save 
        #Deduct entry fee from user's balance
        current_user.balance -= @contest.fee
        bal = Balance.where(user_id: current_user.id).take
        bal.amount -= @contest.fee
        bal.save
        current_user.save

        deduct_amount = ((@contest.fee) * -1.00)

        #Create new transaction
        entryTrans = Transaction.new(user_id: current_user.id, amount: deduct_amount, description: "Contest Entry: Contest ID: #{@contest.id}", current_balance: current_user.balance )
        entryTrans.save

        @contest.curr_size += 1
        @contest.save

        format.html { redirect_to contests_path, notice: 'Lineup was successfully created.' }
        format.json { render :show, status: :created, location: @lineup  }
      else
        format.html { render :new }
        format.json { render json: @lineup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lineups/1
  # PATCH/PUT /lineups/1.json
  def update
    @lineup = Lineup.find(params[:id])
    if @lineup.user_id != current_user.id
      redirect_to contests_path
    end
    @contest = Contest.find(@lineup.contest_id)
    @players = LineupPlayer.where(lineup_id: @lineup.id)

    @players.destroy_all


    respond_to do |format|
      if @lineup.update(lineup_params)
        format.html { redirect_to @contest, notice: 'Lineup was successfully updated.' }
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

    if ((Time.now - @contest.start_time) >= -600)
      respond_to do |format|
        redirect_to contests_url, notice: "You cannot cancel an entry within 10 minutes of the Contest\'s start time"
        return
      end 
    end

    returnBal = Balance.where(user_id: current_user.id).take
    returnBal.amount += @contest.fee
    returnBal.save

    returnUser = User.find(current_user.id)
    returnUser.balance += @contest.fee
    returnUser.save

    refundTrans = Transaction.new(user_id: @lineup.user_id, amount: @contest.fee, description: "Entry Canceled: Contest ID: #{@contest.id}", current_balance: current_user.balance)
    refundTrans.save

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
      params.require(:lineup).permit(:user_id, :contest_id, :gametype)
    end
end
