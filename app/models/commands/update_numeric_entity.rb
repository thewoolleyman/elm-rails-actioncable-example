module Commands
  class UpdateNumericEntity
    def invoke(data)
      singleton_entity_id = 1
      entity = NumericEntity.find_by_id(singleton_entity_id)
      unless entity
        # NOTE: We don't bother with command/event support for creating a numeric entity, we assume always exactly one
        entity = NumericEntity.create(id: singleton_entity_id, integer: 0)
      end
      integer = data.fetch('integer')
      entity.update_attributes!(integer: integer)

      # generate event
      event = ::NumericEntityUpdated.new(
        data: JSON.generate({
          entityId: singleton_entity_id.to_s,
          integer: entity.integer,
        })
      )
      event.save!
    end
  end
end
