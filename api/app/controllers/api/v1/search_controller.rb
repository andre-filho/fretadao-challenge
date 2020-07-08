class Api::V1::SearchController < ApplicationController
  def search_profiles
    @profiles = Profile.search_by_term(params[:query])
    render json: @profiles
  end
end
