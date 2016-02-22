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

  def payout
    @slate = Slate.find(params[:id])
    @contests = Contest.where(slate_id: @slate.id).where(paid_out: false)

    @contests.each do |c|
      if c.payment_structure == 1
        pay5050(c)
        c.paid_out = true
        c.save

      end

        
  
    end
    redirect_to contests_path
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
        contests = Contest.where(slate_id: @slate.id).all
        contests.each do |c|
          c.start_time = @slate.start_time
          c.save
        end
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

  def pay5050(aCon)
    @contest = aCon
    if current_user.permissions != 2
      redirect_to contests_path
    end
    if @contest.curr_size <= @contest.max_size / 4
      lines = Lineup.where(contest_id: @contest.id)
      lines.each do |l|
        Balance.where(user_id: l.user_id).first
        returnUser = User.find(l.user_id).first
        returnUser.balance += @contest.fee
        returnUser.save
        refundTrans = Transaction.new(user_id: l.user_id, amount: @contest.fee, 
          description: "Contest Refund: Contest ID: #{@contest.id} ")
        refundTrans.save
      end
      #RETURN MONEY TO LINEUP OWNER AND EXIT
    end

    lines = Lineup.where(contest_id: @contest.id).all
    #linesArray = Array.new
    scores = Array.new

    if @contest.curr_size != @contest.max_size
      prizePool = (0.90 * (@contest.curr_size * @contest.fee)).floor
      numPaid = (prizePool/(@contest.fee * 1.8)).floor

    else
      prizePool = @contest.prize_pool
      numPaid = (@contest.max_size/2.0).floor
    end

    lines.each do |l|
      #linesArray += l
      calcTotalScore(l)
      scores.append(l.total_score)
    end

    lines = lines.order(total_score: :desc)
    #linesArray.sort! { |a,b| a.total_score <=> b.total_score }

    cutoffScore = lines[numPaid - 1]

    cutoffCount = (scores.grep(cutoffScore).size).to_f

    cutoffLines = lines.where(total_score: cutoffScore).all

    cutoffLines.each do |cl|
      cutoffUser = User.find(cl.user_id)
      cutoffUser.balance += ((1.8 * @contest.fee)/cutoffCount)
      cutoffUser.total_winnings += ((1.8 * @contest.fee)/cutoffCount)
      cutoffUser.save


      cutoffBalance = Balance.where(user_id: cl.user_id)
      cutoffBalance.amount += ((1.8 * @contest.fee)/cutoffCount)
      cutoffBalance.save

      payTrans = Transaction.new(user_id: cl.user_id, amount: (1.8 * @contest.fee)/cutoffCount), 
        description: "Contest Payout: Contest ID: #{@contest.id} ")
      payTrans.save

    end

    #PAY EVERYONE ELSE WHO SCORE > CUTOFF

    payLines = lines[0..numPaid - 1]

    payLines.each do |line|
      payUser = User.find(line.user_id)
      payUser.balance += (1.8 * @contest.fee)
      payUser.total_winnings += (1.8 * @contest.fee)
      payUser.save

      payBalance = Balance.where(user_id: line.user_id).first
      payBalance.amount += (1.8 * @contest.fee)
      payBalance.save

      payTrans = Transaction.new(user_id: line.user_id, amount: (1.8 * @contest.fee)), 
        description: "Contest Payout: Contest ID: #{@contest.id} ")
      payTrans.save

    end
    redirect_to @contest
  end

  def payDoubleUp
    if current_user.permissions != 2
      redirect_to contests_path
    end
    @contest = Contest.find(params[:contest_id])
    if @contest.curr_size <= @contest.max_size / 4
      lines = Lineup.where(contest_id: @contest.id)
      lines.each do |l|
        Balance.where(user_id: l.user_id).first
        returnUser = User.find(l.user_id).first
        returnUser.balance += @contest.fee
        returnUser.save
      end
      #RETURN MONEY TO LINEUP OWNER AND EXIT
    end

    lines = Lineup.where(contest_id: @contest.id).all
    #linesArray = Array.new
    scores = Array.new

    if @contest.curr_size != @contest.max_size
      prizePool = (0.90 * (@contest.curr_size * @contest.fee)).floor
      numPaid = (curr_size * 0.45).floor

    else
      prizePool = @contest.prize_pool
      numPaid = (@contest.max_size * 0.45).floor
    end

    lines.each do |l|
      #linesArray += l
      calcTotalScore(l)
      scores.append(l.total_score)
    end

    lines = lines.order(total_score: :desc)
    #linesArray.sort! { |a,b| a.total_score <=> b.total_score }

    cutoffScore = lines[numPaid - 1]

    cutoffCount = (scores.grep(cutoffScore).size).to_f

    cutoffLines = lines.where(total_score: cutoffScore).all

    cutoffLines.each do |cl|
      cutoffUser = User.find(cl.user_id)
      cutoffUser.balance += ((2 * @contest.fee)/cutoffCount)
      cutoffUser.total_winnings += ((2* @contest.fee)/cutoffCount)
      cutoffUser.save


      cutoffBalance = Balance.where(user_id: cl.user_id)
      cutoffBalance.amount += ((2* @contest.fee)/cutoffCount)
      cutoffBalance.save
    end

    #PAY EVERYONE ELSE WHO SCORE > CUTOFF

    payLines = lines[0..numPaid - 1]

    payLines.each do |line|
      payUser = User.find(line.user_id)
      payUser.balance += (2 * @contest.fee)
      payUser.total_winnings += (2 * @contest.fee)
      payUser.save

      payBalance = Balance.where(user_id: line.user_id).first
      payBalance.amount += (2 * @contest.fee)
      payBalance.save
    end
    redirect_to @contest

  end

end
