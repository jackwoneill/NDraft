class AdminController < ApplicationController
  before_filter :ensure_admin

	def index

		
	end

  def slates
    @slates = Slate.all
  end

  def contests

  end

  def verifyAccounts
    
  end


  
end
