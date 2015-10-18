class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
    	t.attachment :file_attachment
    end
  end
end
