class ProgramsController < ApplicationController
  def index
    # @program =
    # retrieve all movies from api
    # @movies = Movie.all
    text = I18n.t("hello")
    render inertia: "ProgramPage", props: {
      text: text
    }
  end
end
