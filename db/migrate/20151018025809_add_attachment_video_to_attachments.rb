class AddAttachmentVideoToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :attachments, :video
  end
end
