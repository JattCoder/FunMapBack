class CreateFamily < ActiveRecord::Migration[5.0]

    def change
        create_table :families do |f|
            f.integer :admin_id
            f.string :name
            f.string :code
            f.string :admins
            f.string :users
            f.string :created_at
            f.string :date
        end
    end

end