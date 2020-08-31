class MapsController < ApplicationController
    skip_before_action :verify_authenticity_token
    # Item Details
    # Name,Status,Address,Geo,Icon,Photos,PlaceID,Rating,Ratings,Types
    # client.spots(41.4272877, -81.70209, :types => ['restaurent','food'] :name => 'burger king', :radius => 10000).length --> to get data using Region, Location and Radius
    # client.spots_by_query('Pizza near Miami Florida')

    def searchPlaces
        results = []
        status = ''
        input = params[:input]+' in '+'['+params[:latitude]+','+params[:longitude]+']'
        search = GooglePlaces::Client.new('AIzaSyDMCLs_nBIfA8Bw9l50nSRwLOUByiDel9U')
        byebug
        search.spots_by_query(input).each do |place|
            status = ''
            if place.json_result_object['opening_hours']
                status = place.json_result_object['opening_hours']['open_now']
            end
            results << {
                'name' => place.json_result_object['name'],
                'address' => place.json_result_object['formatted_address'],
                'status' => status,
                'geo' => place.json_result_object['geometry']['location'],
                'placeid' => place.json_result_object['place_id'],
                'rating' => place.rating,
                'types' => place.json_result_object['types'],
                'icon' => place.json_result_object['icon']
            }
        end
        render json: results
    end

    def searchPlace
        places = []
        count = 0
        distance = GoogleMapsService::Client.new(key: 'AIzaSyDMCLs_nBIfA8Bw9l50nSRwLOUByiDel9U')
        search = GooglePlaces::Client.new('AIzaSyDMCLs_nBIfA8Bw9l50nSRwLOUByiDel9U')
        search.spots(params[:lat],params[:lng], :name => params[:input], :radius => 10000).each do |place|
            data = distance.distance_matrix([params[:lat],params[:lng]],
                [place.json_result_object['geometry']['location']['lat'],place.json_result_object['geometry']['location']['lng']])
            #places << {
            #    'name' => place.json_result_object['name'],
            #    'address' => places.json_result_object['formatted_address'],
            #    'status' => place.json_result_object['opening_hours'],#['open_now']
            #    'geo' => place.json_result_object['geometry']['location'],
            #    'placeid' => place.json_result_object['place_id'],
            #    'rating' => place.rating,
            #    'types' => place.json_result_object['types'],
            #    'distance' => data[:rows][0][:elements][0][:distance][:text],
            #    'duration' => data[:rows][0][:elements][0][:duration][:text]
            #}
            places << place
        end
        search.spots_by_query(params[:input]).each do |place|
            selected = false
            places.each do|spot|
                selected = true if spot.json_result_object['place_id'] == place.json_result_object['place_id']
            end
            if selected == false
                data = distance.distance_matrix([params[:lat],params[:lng]],
                    [place.json_result_object['geometry']['location']['lat'],place.json_result_object['geometry']['location']['lng']])
                # places << {
                #    'name' => place.json_result_object['name'],
                #    'address' => places.json_result_object['formatted_address'],
                #    'status' => place.json_result_object['opening_hours'],#['open_now']
                #    'geo' => place.json_result_object['geometry']['location'],
                #    'placeid' => place.json_result_object['place_id'],
                #    'rating' => place.rating,
                #    'types' => place.json_result_object['types'],
                #    'distance' => data[:rows][0][:elements][0][:distance][:text],
                #    'duration' => data[:rows][0][:elements][0][:duration][:text]
                # }
                places << place
            end
        end
        render json: {'code' => 'Success', 'message' => places, 'result' => true}
    end

    def buildRoute
        maps = GoogleMapsService::Client.new(key: 'AIzaSyDMCLs_nBIfA8Bw9l50nSRwLOUByiDel9U')
        matrix = maps.directions(origin, destination, mode: 'driving', language: 'en',)
        render json: {'code' => 'Success', 'message' => matrix, 'result' => true}
    end

end
