module Commands
  class CreateTextualEntity
    def invoke(data)
      entity = TextualEntity.create!(text: '')

      # generate event
      event = ::TextualEntityCreated.new(
        data: JSON.generate({
          entityId: entity.id.to_s,
          text: entity.text,
        })
      )
      event.save!
    end
  end
end
