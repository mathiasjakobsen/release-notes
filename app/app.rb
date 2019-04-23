require 'sinatra'
require 'redcarpet'
require 'graphql/client'
require 'graphql/client/http'

OWNER = ENV['OWNER']
BEARER = ENV['BEARER']
TOKENS = ENV['TOKENS'].split(',')

class ReleaseApp < Sinatra::Base
  http = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(_)
      {
        'Authorization' => "bearer #{BEARER}"
      }
    end
  end

  schema = GraphQL::Client.load_schema(http)
  client = GraphQL::Client.new(schema: schema, execute: http)

  QUERY = client.parse <<-'GRAPHQL'
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        id
        descriptionHTML
        releases(first: 25) {
          totalCount
          edges {
            cursor
            node {
              description
              createdAt
              name
              publishedAt
            }
          }
        }
      }
    }
  GRAPHQL

  get '/' do
    'So.. What about the pope?'
  end

  get '/:repo' do
    return 'No.' unless TOKENS.include?(params['bearer'])

    name = params[:repo]
    releases = client.query(QUERY, variables: { owner: OWNER, name: name })
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    releases = releases.data.repository.releases.edges.map do |edge|
      {
        title: edge.node.name,
        created_at: Date.iso8601(edge.node.created_at).strftime,
        published_at: Date.iso8601(edge.node.published_at).strftime,
        html: markdown.render(edge.node.description)
      }
    end

    erb :releases, locals: { releases: releases }
  end
end
