class MatchesController < ApplicationController
  before_action :set_match, only: [:edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    #should be the following line when our matching feature is implemented
    @user = current_user
    #@matches = Match.All
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @user = current_user
    #@match = params[:id]
    #get all the matched mentors/mentees for this user
    @matches = nil
    if @user.role == "Mentee"
      @matches = Match.where(mentee_id: @user.id)
    elsif @user.role == "Mentor"
      @matches = Match.where(mentor_id: @user.id)
    end
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @user = current_user
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:mentor_id, :mentee_id, :created_at, :updated_at)
    end
end
