class FamilyController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        groups = []
        added = false
        Family.all.each do |g|
            added = false
            if g.admin_id == params[:id].to_i
                groups << g
            else
                if g.admins != ''
                    g.admins.split().each do |a|
                        if a == params[:id]
                            groups << g
                        else
                            if g.users != ''
                                g.users.split().each do |u|
                                    if u == params[:id]
                                        groups << g
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if groups.length == 0
            render json: {'code' => 'Success', 'message' => 'Please Create New Event or Group', 'result' => false}
        else
            render json: {'code' => 'Success', 'message' => groups, 'result' => true}
        end
    end

    def create
        count = 0
        code = ''
        while count < 6
            num = rand(10)
            code += num.to_s
            count += 1
        end
        fam = Family.new(admin_id: params[:id].to_i, name: params[:name], code:code, admins: params[:id], users: '', date:'', created_at: Time.now)
        if fam.save
            render json: {'code' => 'Success', 'message' => fam, 'result' => true}
        else
            render json: {'code' => 'Error', 'message' => 'Failed to save', 'result' => false}
        end
    end

end