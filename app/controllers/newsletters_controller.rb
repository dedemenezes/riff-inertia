class NewslettersController < ApplicationController
  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.save
      flash[:success] = "Obrigado! Você foi inscrito na newsletter."
      redirect_to request.referer || root_path(anchor: "newsletter"), status: :see_other
    else
      flash[:error] = "Não foi possível inscrever. Verifique seu email."
      redirect_to request.referer || root_path(anchor: "newsletter"), status: :see_other
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:email)
  end
end
