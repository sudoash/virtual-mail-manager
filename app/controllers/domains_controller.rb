class DomainsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :auth_only, :_add_crumbs

  def index
    @domains = Domain.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @domain = Domain.find(params[:id])
    add_crumb @domain.domain
  end

  def new
    @domain = Domain.new
    add_crumb 'New'
  end

  def edit
    @domain = Domain.find(params[:id])
    add_crumb @domain.domain, domain_path(@domain)
    add_crumb 'Edit'
  end

  def create
    @domain = Domain.new(params[:domain])
    add_crumb 'New'

    if @domain.save
      redirect_to(@domain, :notice => 'Domain was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @domain = Domain.find(params[:id])
    add_crumb @domain.domain, domain_path(@domain)
    add_crumb 'Edit'

    if @domain.update_attributes(params[:domain])
      redirect_to(@domain, :notice => 'Domain was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy

    redirect_to(domains_path, :notice => 'Domain was successfully deleted.')
  end

  private

  def _add_crumbs
    add_crumb 'Domains', (domains_path unless params[:action] == "index")
  end

  def sort_column
    Domain.column_names.include?(params[:sort]) ? params[:sort] : "domain"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
