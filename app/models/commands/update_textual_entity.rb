module Commands
  class UpdateTextualEntity
    def invoke(data)
      entity = TextualEntity.find_by_id(1)
      text = data.fetch('text')
      entity.update_attributes!(text: text)

      # generate event
      event = ::TextualEntityUpdated.new(
        data: JSON.generate({
          entityId: entity.id.to_s,
          text: entity.text,
        })
      )
      event.save!
    end
  end
end
