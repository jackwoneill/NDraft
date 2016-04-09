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
    @lineup.game = @contest.game

    @slate = Slate.find(@contest.slate_id)

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

    #IF LINEUP IS FOR A LEAGUE OF LEGENDS SLATE
    if @lineup.game == 1

      tops = Array.new
      mids = Array.new
      supports = Array.new
      adcs = Array.new
      junglers = Array.new

      players.each do |player|
        if player.position == "1"
          tops.append(player)
        elsif player.position == "2"
          mids.append(player)
        elsif player.position == "3"
          adcs.append(player)
        elsif player.position == "4"
          supports.append(player)
        elsif player.position == "5"
          junglers.append(player)
                             
        end
      end

      @tops = tops
      @mids = mids
      @adcs = adcs
      @supports = supports
      @junglers = junglers

    end
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


    @games.each do |game|
      teams.append(Team.find(game.team_1))
      teams.append(Team.find(game.team_2))

      players += (Player.where(team_id: game.team_1).all)
      players += (Player.where(team_id: game.team_2).all)

    end

    @players = players.uniq
    @teams = teams.uniq

    #IF IT IS A LEAGUE SLATE
    if @lineup.game == 1

      tops = Array.new
      mids = Array.new
      supports = Array.new
      adcs = Array.new
      junglers = Array.new

      players.each do |player|
        if player.position == "1"
          tops.append(player)
        elsif player.position == "2"
          mids.append(player)
        elsif player.position == "3"
          adcs.append(player)
        elsif player.position == "4"
          supports.append(player)
        elsif player.position == "5"
          junglers.append(player)
                             
        end
      end

      @tops = tops
      @mids = mids
      @adcs = adcs
      @supports = supports
      @junglers = junglers

    end
  end

  # POST /lineups
  # POST /lineups.json
  def create
    @lineup = Lineup.new(lineup_params)
    @contest = Contest.find(params[:contest_id])
    @slate = Slate.find(@contest.slate_id)

    if current_user.balance < @contest.fee
      redirect_to contests_path and return
    end

    if @contest.curr_size == @contest.max_size
      redirect_to contests_path and return
    end

    if @slate.start_time < Time.now
      redirect_to contests_path and return
    end

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

    player_1 = Player.find(@lineup.player_1)
    player_2 = Player.find(@lineup.player_2)
    player_3 = Player.find(@lineup.player_3)
    player_4 = Player.find(@lineup.player_4)
    player_5 = Player.find(@lineup.player_5)
    player_6 = Player.find(@lineup.player_6)
    player_7 = Player.find(@lineup.player_7)
    player_8 = Player.find(@lineup.player_8)

    players += [player_1.id, player_2.id, player_3.id, player_4.id, player_5.id, player_6.id, player_7.id, player_8.id]
    players = players.uniq

    if players.length != 8
      redirect_to contests_path
      return
    end

    players.each do |player|
      totSalary += Player.find(player).salary
      print "TOT SAL = #{totSalary}"
    end

    if totSalary > 60000
      redirect_to :back, notice: "Total salary cannot exceed $60,000"
      return
    end

    #ENSURE PLAYERS ARE PLAYING IN GAME IN SLATE #
    if !team_ids.include? player_1.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_2.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_3.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_4.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_5.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_6.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_7.team_id
      redirect_to contests_path and return
    elsif !team_ids.include? player_8.team_id
      redirect_to contests_path and return
    end

    @lineup.contest_id = params[:contest_id]
    @lineup.user_id = current_user.id

    # if @lineup.save 

    # end



    #can before_save go here?

    respond_to do |format|
      if @lineup.save 
        current_user.balance -= @contest.fee
        bal = Balance.where(user_id: current_user.id).take
        bal.amount -= @contest.fee
        bal.save
        current_user.save

        deduct_amount = ((@contest.fee) * -1.00)

        entryTrans = Transaction.new(user_id: current_user.id, amount: deduct_amount, description: "Contest Entry: Contest ID: #{@contest.id}", current_balance: current_user.balance )
        entryTrans.save

        @contest.curr_size += 1
        @contest.save

        format.html { redirect_to @contest, notice: 'Lineup was successfully created.' }
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
    @contest = Contest.find(@lineup.contest_id)

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
      params.require(:lineup).permit(:player_1, :player_2, :player_3, :player_4, :player_5, :player_6, :player_7, :player_8, :user_id, :contest_id, :game)
    end
end
