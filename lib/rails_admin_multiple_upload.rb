require "simple_form"
require "rails_admin_multiple_upload/engine"

module RailsAdminMultipleUpload
end

require 'rails_admin/config/actions'

module RailsAdmin
	module Config
		module Actions
			class MultipleUpload < Base
				RailsAdmin::Config::Actions.register(self)
				register_instance_option :member do
					true
				end

				register_instance_option :link_icon do
					'icon-upload'
				end

				register_instance_option :http_methods do
					[:get, :post]
				end

				register_instance_option :controller do
					Proc.new do
						@response = {}

						if request.post?
							dest   = "#{@object.nested_attributes_options.map{|k, v| k}.first}_attributes"
							dest_s = dest.to_sym

							files  = params[@object.class.name.downcase.to_sym][dest_s]
							files.each do | file |
								@object.docs << Doc.create(data: file[:file])
							end

							redirect_to action: "index"
							#@response[:notice] = results[:success].join("<br />").html_safe if results[:success].any?
							#@response[:error] = results[:error].join("<br />").html_safe if results[:error].any?
						else
							render :action => @action.template_name
						end
					end
				end
			end
		end
	end
end
