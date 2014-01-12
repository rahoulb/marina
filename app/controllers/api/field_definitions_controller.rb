class Api::FieldDefinitionsController < ApplicationController
  respond_to :json

  def create
    field_definition_builder.build_from field_definition_params do | created |
      render partial: '/api/field_definitions/field_definition', locals: { field_definition: created }, status: 201
    end
  end

  protected

  def field_definition_builder
    Marina::Commands::Builders::FieldDefinitionBuilder.new user: current_user, data_store: Marina::Db::FieldDefinition
  end

  def field_definition_params
    params.require(:field_definition).permit(:name, :label, :kind, { :options => [] })
  end
end
