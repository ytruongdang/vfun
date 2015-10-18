class AddDimentionColumnAttachment < ActiveRecord::Migration
  def change
  	add_column :attachments, :dimention, :string
  end
end
