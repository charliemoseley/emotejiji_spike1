ENV['RACK_ENV'] = "test"

# Load up rspec and Emotejiji
require 'rspec'
require 'rack/test'
require File.expand_path('../../config/application', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods

  config.before(:suite) do
    # Setup the Neo4j test database before rspec runs
    Neo4j::Config[:debug_java]   = true
    Neo4j::Config[:storage_path] = File.join(Dir.tmpdir, "neo4j_rspec")
    # faster tests
    Neo4j::Config[:identity_map] = (ENV['IDENTITY_MAP'] == "true")
    # this is normally set in the rails rack middleware
    Neo4j::IdentityMap.enabled   = (ENV['IDENTITY_MAP'] == "true")

    # Clear out any old test dbs and create the director for the new one
    FileUtils.rm_rf Neo4j::Config[:storage_path]
    Dir.mkdir(Neo4j::Config[:storage_path])
  end

  config.after(:suite) do
    Neo4j.shutdown if Neo4j.running?
    FileUtils.rm_rf Neo4j::Config[:storage_path]
  end

  config.before(:all, type: :mock_db) do
    Neo4j.shutdown
    Neo4j::Core::Database.default_embedded_db= MockDb
    Neo4j.start
  end

  config.after(:all, type: :mock_db) do
    Neo4j.shutdown
    Neo4j::Core::Database.default_embedded_db = nil
  end
end

# Rack Test Helper
def app
  Emotejiji::API.new
end

# Test DB Management Methods
def start_transaction
  finish_tx if @tx
  @tx = Neo4j::Transaction.new
end

def end_transaction
  return unless @tx
  @tx.success
  @tx.finish
  @tx = nil
end

def close_and_reopen_transaction
  end_transaction
  start_transaction
end

def failed_transaction_cleanup
  return unless @tx
  @tx.failure
  @tx.finish
  @tx = nil
end
