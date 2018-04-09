class AthletesController < ApplicationController

  def index
    sorted_results
    @athletes = Athlete.all
  end

  def create
    athlete = Athlete.new(athlete_params)
    if athlete.save
      Result.create(athlete: athlete)
      flash[:success] = 'Athlete successfully created'
       redirect_to root_path
    else
      flash[:error] = athlete.errors.full_messages.first
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    binding.pry
        athlete = Athlete.find(params[:id])
    athlete.open_or_close_voting
    redirect_to root_path
  end


  private

  def sorted_results
    results = Result.all
    @sorted_results = results.sort_by { |result| result[:score] }.reverse
    @sorted_results.each { |result| result.valid_score = true if result.number_of_votes > 4 }
    @sorted_results
  end

  def athlete_params
    params.require(:athlete).permit(:name, :age, :home, :image, :starttime)
  end
end
