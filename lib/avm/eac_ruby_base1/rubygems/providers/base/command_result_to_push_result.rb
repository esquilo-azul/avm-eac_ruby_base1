# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      module Providers
        class Base
          class CommandResultToPushResult
            acts_as_instance_method
            common_constructor :provider, :command_result

            RESULT_STRUCT = ::Struct.new(:type, :message)

            # @return [RESULT_STRUCT]
            def result
              RESULT_STRUCT.then do |v|
                v.new(*v.members.map { |e| send(e) })
              end
            end

            # @return [String]
            def message
              %i[stdout stderr].map { |e| "#{command_result.fetch(e)}\n" }.join
            end

            # @return [Symbol]
            def type
              ::Avm::EacRubyBase1::Rubygems::Providers::Base.lists.push_result_type.value_validate!(
                provider.push_gem_command_exit_codes.fetch(
                  command_result.fetch(:exit_code)
                )
              )
            end
          end
        end
      end
    end
  end
end
