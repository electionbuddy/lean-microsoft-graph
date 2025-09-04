# frozen_string_literal: true

module LeanMicrosoftGraph
  module Resources
    class GroupsResource
      class Members
        include Enumerable

        def initialize(response)
          @response = response
        end

        def each(&block)
          collection.each(&block)
        end

        def next_batch_reference = @response[:'@odata.nextLink']

        private

        def collection
          @collection ||= @response[:value].map { |member| Member.new(member) }
        end
      end
    end
  end
end