class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin, only: [:new, :create, :destroy, :edit, :update, :pay5050]

  # GET /contests
  # GET /contests.json
  def index
    c = Array.new
    cons = Array.new

    if current_user.permissions == 2
      @contests = Contest.where(paid_out: false).all
      return
    end

    c += Contest.where('start_time >?', Time.now)

    c.each do |c|
      cons.append(c) if c.max_size != c.curr_size
    end

    @contests = cons.uniq

  end

  def upcoming
    cons = Array.new

    lines = Lineup.where(user_id: current_user.id)
    l = Array.new

    lines.each do |line|
      c = Contest.find(line.contest_id)
      if c.start_time > Time.now
        l.append(line)
        cons.append(c)
      end
    end

    @lineups = l.uniq
    @contests = cons.uniq

  end

  def live
    cons = Array.new

    lines = Lineup.where(user_id: current_user.id)
    l = Array.new

    lines.each do |line|
      c = Contest.find(line.contest_id)
      if c.start_time < Time.now && c.paid_out == false
        l.append(line)
        cons.append(c)
      end
    end

    @lineups = l.uniq
    @contests = cons.uniq
  end

  def completed
    cons = Array.new

    lines = Lineup.where(user_id: current_user.id)
    l = Array.new

    lines.each do |line|
      c = Contest.find(line.contest_id)
      if c.start_time < Time.now
        if contest.closed
          if contest.paid_out?
            l.append(line)
            cons.append(c)
          end
        end
      end
    end

    # @lineups = l.uniq
    # @contests = cons.uniq

  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @games = Game.where(slate_id: @contest.slate_id)
    print("games=#{@games.count}")
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

    if @contest.start_time < Time.now
      @lineups = Lineup.where(contest_id: @contest.id)
      @lineups.each do |line|
        calcTotalScore(line)
      end
      @lineups.order(total_score: :desc).to_a

    end

  end

  # GET /contests/new
  def new
    @slates = Slate.where("start_time > ?", Time.now)
    @teams = Team.all
    @contest = Contest.new
  end

  # GET /contests/1/edit
  def edit
    @slates = Slate.where("start_time > ?", Time.now)
  end

  # POST /contests
  # POST /contests.json
  def create  
    @contest = Contest.new(contest_params)
    @slate = Slate.find(params[:contest][:slate_id])
    @contest.start_time = @slate.start_time
    @contest.curr_size = 0
    @contest.paid_out = false
    @contest.closed = false

    #RECHECK IF NOT FULL

    respond_to do |format|
      if @contest.save
        format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render :show, status: :created, location: @contest }
      else
        format.html { render :new }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contests/1
  # PATCH/PUT /contests/1.json
  def update
    respond_to do |format|
      if @contest.update(contest_params)
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @contest }
      else
        format.html { render :edit }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

 

   

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    if @contest.paid_out == false
      lines = Lineup.where(contest_id: @contest.id)
      if !lines.nil?
        lines.each do |l|
          Balance.where(user_id: l.user_id).first
          returnUser = User.find(l.user_id).first
          returnUser.balance += @contest.fee
          returnUser.save
        end
      end
    end

      #RETURN MONEY TO LINEUP OWNER AND EXIT
    @contest.destroy
    respond_to do |format|
      format.html { redirect_to contests_url, notice: 'Contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contest
      @contest = Contest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contest_params
      params.require(:contest).permit(:title, :fee, :start_time, :max_size, :curr_size, :prize_pool, :slate_id, :payment_structure)
    end
end
