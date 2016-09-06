module Commands
  class UpdateNumber
    def invoke(data)
      entity = NumericEntity.find_by_id(1)
      unless entity
        entity = NumericEntity.create(id: 1, integer: 0)
      end
      integer = data.fetch('integer')
      entity.update_attributes!(integer: integer)

      # generate event
      event = ::NumericEntityUpdated.new(
        data: JSON.generate({
          integer: entity.integer,
        })
      )
      event.save!
    end
  end
end
