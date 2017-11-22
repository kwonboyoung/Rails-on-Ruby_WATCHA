class Admin::ApplicationController < ApplicationController

	before_action :check_admin
	layout 'admin'
	
	private
	def check_admin
		# if current_user.admin?
		# 	redirect_to admin_users_path
		# else
		# 	redirect_to :back

		unless user_signed_in? && current_user.admin?
			redirect to root_path, alert:"관리자 계정으로 로그인 하셔야해용"
		end
	end
end