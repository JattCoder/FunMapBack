class CreateFpin < ActiveRecord::Migration[5.0]

    def change
        create_table :fpins do |a|
            a.string :account_id
            a.string :code
            a.string :time
        end
    end

end