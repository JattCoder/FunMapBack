class CreateFav < ActiveRecord::Migration[5.0]

    def change
        create_table :favs do |f|
            f.integer :account_id
            f.string :name
            f.string :address
            f.float :latitude
            f.float :longitude
            f.string :placeid
            f.string :type
            f.string :created_at
        end
    end

end