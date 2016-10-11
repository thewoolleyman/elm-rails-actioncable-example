module Commands
  class UpdateTextualEntity
    def invoke(data)
      entity_id = data.fetch('entityId').to_i
      entity = TextualEntity.find_by_id(entity_id)
      text = data.fetch('text')
      entity.update_attributes!(text: text)

      # generate event
      event = ::TextualEntityUpdated.new(
        data: JSON.generate({
          entityId: entity_id.to_s,
          text: entity.text,
        })
      )
      event.save!
    end
  end
end
