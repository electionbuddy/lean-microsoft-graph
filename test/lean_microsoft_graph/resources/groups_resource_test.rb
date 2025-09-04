# frozen_string_literal: true

require 'test_helper'

class LeanMicrosoftGraph::Resources::GroupsResourceTest < Minitest::Test
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
    connection = Faraday.new { |faraday| faraday.adapter :test, @stubs }
    @groups_resource = ::LeanMicrosoftGraph::Resources::GroupsResource.new(connection)
  end

  def test_get_member_count_by_group_id
    group_id = 'my-group-id'
    @stubs.get("/groups/#{group_id}/members/$count") { |_env| [200, {}, '4'] }

    count = @groups_resource.get_member_count_by_group_id(group_id)

    assert_equal 4, count
  end

  def test_get_members_by_group_id
    group_id = 'my-group-id'
    @stubs.get("/groups/#{group_id}/members/microsoft.graph.user?") do |_env|
      [200, {}, { value: [{ id: '1' }, { id: '2' }], '@odata.nextLink': 'url' }.to_json]
    end

    members = @groups_resource.get_members_by_group_id(group_id, 2)

    assert_equal([{ id: '1' }, { id: '2' }], members.map { |member| member.to_h.slice(:id) })
    assert_equal 'url', members.next_batch_reference
  end

  def test_get_members_by_reference
    @stubs.get('/url') do |_env|
      [200, {}, { value: [{ id: '3' }, { id: '4' }] }.to_json]
    end

    members = @groups_resource.get_members_by_reference('url')

    assert_equal([{ id: '3' }, { id: '4' }], members.map { |member| member.to_h.slice(:id) })
    assert_nil members.next_batch_reference
  end

  def teardown
    @stubs.verify_stubbed_calls
  end
end