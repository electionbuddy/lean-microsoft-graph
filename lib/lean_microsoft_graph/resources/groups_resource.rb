# frozen_string_literal: true

module LeanMicrosoftGraph
  module Resources
    class  GroupsResource < ::LeanMicrosoftGraph::Resource
      def get_member_count_by_group_id(id)
        get_request("groups/#{id}/members/$count") do |req|
          req.headers['ConsistencyLevel'] = 'eventual'
        end
      end

      def get_members_by_group_id(id, per_page)
        response = get_request("groups/#{id}/members/microsoft.graph.user?") do |req|
          req.params['$top'] = per_page
        end

        Members.new(response)
      end

      def get_members_by_reference(url)
        response = get_request(url)

        Members.new(response)
      end
    end
  end
end