require 'swagger_helper'
<% name= controller_path.split('/')[2].try!(:singularize).try!(:titleize) %>
RSpec.describe '<%= name %>', type: :request do
  let(:account) { singleton_account }
  let(:customer) { account.customers.first }
  let(:api_key) { account.users.first.api_key }

  <% @routes.sort_by{|route| route.first.size}.each do | template, path_item | %>
  path '<%= template.gsub('/api/v1','') %>' do
<% path_item[:actions].each do | action, details | -%>
    <%= action %> '<%= details[:summary] %>'  do
      tags '<%=name %>'
      security [apiKey: []]
      consumes 'application/json'
      <% unless path_item[:params].empty? -%>
      # You'll want to customize the parameter types...
<% path_item[:params].each do |param| -%>
      parameter name: '<%= param %>', in: :path, type: :integer
<% end -%>
<% end -%>

      response '200', 'successful' do
        description ""
<% unless path_item[:params].empty? -%>

<% path_item[:params].each do |param| -%>
        let(:<%= param %>) { 123 }
<% end -%>
<% end -%>

        run_test! do |response|
          data = JSON.parse(response.body)
        end
      end

      response '404', 'Invalid request' do
        let(:id) { -1 }
        run_test! do |response|
          data = JSON.parse(response.body)
        end
      end
    end

<% end -%>
  end
<% end -%>
end
