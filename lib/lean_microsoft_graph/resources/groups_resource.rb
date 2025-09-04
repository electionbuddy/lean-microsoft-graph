# frozen_string_literal: true

module LeanMicrosoftGraph
  module Resources
    class  GroupsResource < ::LeanMicrosoftGraph::Resource
      def get_members_by_group_id(id)
        response = get_request("groups/#{id}/members/microsoft.graph.user?")

        Members.new(response)
      end
    end
  end
end