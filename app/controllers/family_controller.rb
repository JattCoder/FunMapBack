class FamilyController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        groups = []
        added = false
        Family.all.each do |g|
            added = false
            if g.admin_id == params[:id].to_i
                groups << [g]
            else
                if g.admins != ''
                    g.admins.split().each do |a|
                        if a == params[:id]
                            groups << [g]
                        else
                            if g.users != ''
                                g.users.split().each do |u|
                                    if u == params[:id]
                                        groups << [g]
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
            count = 0
            groups.each do |group|
                account = []
                group.each do |g|
                    if g.admins == ''
                        if g.users == ''
                            Family.destroy(g.id)
                            next
                        else
                            random = rand(g.users.split().length)
                            fam = Family.find_by(id: g.id)
                            fam.admins = g.users.split()[random].to_s
                            fam.users = g.users.tr(g.users.split()[random].to_s, '')
                            if fam.save
                                g.admins = fam.admins
                                g.users = fam.users
                            end
                        end
                    end
                    g.admins.split().each do |a|
                        acc = Account.find_by(id: a.to_i)
                        account << {
                            'id' => acc.id,
                            'name' => acc.name,
                            'email' => acc.email,
                            'photo' => acc.photo,
                            'phone' => acc.phone,
                            'method' => acc.method,
                            'member_type' => acc.member_type,
                            'role' => 'Admin'
                        }
                    end
                    if g.users != ''
                        g.users.split().each do |u|
                            acc = Account.find_by(id: u.to_i)
                            account << {
                                'id' => acc.id,
                                'name' => acc.name,
                                'email' => acc.email,
                                'photo' => acc.photo,
                                'phone' => acc.phone,
                                'method' => acc.method,
                                'member_type' => acc.member_type,
                                'role' => 'User'
                            }
                        end
                    end
                end
                groups[count] << account
                count += 1
            end
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

    def sendInvitation
        sender = Account.find_by(id: params[:sid])
        if sender
            newMem = Account.find_by(email: params[:email])
            FamilyMailer.send_invitation({
                :email => newMem ? newMem.email : params[:email],
                :subject => newMem ? 'Invitation from FunMap' : 'New Family Invitation',
                :name => newMem ? newMem.name : 'Friend',
                :message => 'You have been invited to '
            }).deliver_now
            render json: {'code'=>'Success','message'=>'Email has been sent','result'=>true}
        else
            render json: {'code'=>'Error','message'=>'You must login before user search','result'=>false}
        end
    end

end