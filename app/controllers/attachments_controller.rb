class AttachmentsController < ApplicationController
	def new
		@attachment = Attachment.new
	end

	def create
		@attachment = Attachment.new(attachment_params)
      	if @attachment.save
        	respond_to do |format|
        		format.html( redirect_to new_video_path, @attachment )
          		format.json { render json: @attachment }
          	end
      	else        	
        	respond_to do |format|
          		format.json { render json: @attachment.erorrs }
          	end
        end
	end

	private
		def attachment_params
			params.require(:video).permit(:video)
		end
end