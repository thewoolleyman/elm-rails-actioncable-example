module CqrsEs
  class CommandInvoker
    def invoke_command(command_payload)
      command_invocation_result = nil

      begin
        command_name = command_payload.fetch('name').to_sym
        command_class_name = "::Commands::#{command_name}"
        command_class = command_class_name.constantize
        command = command_class.new

        data = command_payload.fetch('data')

        ActiveRecord::Base.transaction do
          # TODO: select max event sequence with read-lock
          command.invoke(data)
        end

        command_invocation_result = {
          result: :success,
          details: [],
        }
      rescue => e
        Rails.logger.error(e.message + "\n " + e.backtrace.join("\n ")) # TODO: Not a cleaner way built in to Rails?
        command_invocation_result = {
          result: :failure,
          # TODO: don't show raw exception data to clients in prod; could contain sensitive data. Map to generic errors
          details: [
            e.class.to_s,
            e.to_s
          ],
        }
      end

      command_invocation_result
    end
  end
end
