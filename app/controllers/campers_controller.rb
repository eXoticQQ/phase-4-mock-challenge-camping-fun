class CampersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found
rescue_from ActiveRecord::RecordInvalid, with: :invalid_entry
    def index
        campers = Camper.all
        render json: campers, status: :ok
    end

    def show
        camper = find_camper
        render json: camper, serializer: CamperWithActivitiesSerializer, status: :ok
    end

    def create
        camper = Camper.create!(camper_params)
        render json: camper, status: 201
    end

    private

    def find_camper
        Camper.find_by!(id: params[:id])
    end

    def not_found
        render json: {error: 'Camper not found'}, status: :not_found
    end

    def camper_params
        params.permit(:name, :age)
    end

    def invalid_entry(e)
        render json: {errors: e.record.errors.full_messages}, status: 422
    end
end
