require "graphql/rake_task"

GraphQL::RakeTask.new(
  schema_name: "BackendSchema",
  directory: "../graphql-schema/",
  idl_outfile: "backend_schema.graphql"
)
