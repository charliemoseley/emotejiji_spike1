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

  config.after(:each, type: :integration) do
    Neo4j::Transaction.run do
      Neo4j.threadlocal_ref_node = Neo4j::Node.new name: "ref_#{$name_counter}"
      $name_counter += 1
    end
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
