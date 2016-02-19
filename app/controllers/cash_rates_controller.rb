class CashRatesController < ApplicationController
  def index
    @rate = CashRate.new
    @current_rate = CashRate.last
  end

  def create
    CashRate.create(rates_params)
    redirect_to cash_rates_path
  end

  private
  def rates_params
    params.require(:cash_rate).permit(:british, :germany, :france, :spain, :italy, :america, :canada)
  end
end
