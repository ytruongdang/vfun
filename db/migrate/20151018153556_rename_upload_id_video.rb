class RenameUploadIdVideo < ActiveRecord::Migration
  def change
  	rename_column :videos, :upload_id, :attachment_id
  end
end
