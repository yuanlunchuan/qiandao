class CompaniesController < ApplicationController
  before_action :authorize_admin!

  def edit
    @company = current_company
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to edit_company_path, flash: { success: '设置成功' }
    else
      render edit_company_path
    end

  end

  private
    def company_params
      params.require(:company).permit(:name, :address)
      
    end
end
