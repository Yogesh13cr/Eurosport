require "page-object"
require "data_magic"
require "byebug"
require "net/http"
require "dotenv"
require "uri"
require "watir-scroll"
require "bundler"
require "csv"
require "cgi"

# require all bundled gems
Bundler.require :default

# patch string with color methods
require "rainbow/ext/string"

# include monkeypatches from activesupport. add more libraries explicitly if
# need be. don't just require the entire activesupport library. its huge.
require "active_support/core_ext/hash/deep_merge"
require "active_support/core_ext/hash/keys"
require "json"
# require_relative "../pages/page_helpers/network_data_helper.rb"

require_relative "../../../support/paths"

Dotenv.load(File.join(Support::Paths.es_root, ".env"))

require_rel "../../../support/profiles"
PROFILE = Support::Profiles::Cucumber.new(ENV["CUCUMBER_PROFILE"])
require_rel "../../../support"
require_rel "../../../support/analytics/eurosports"
require_rel "../../../support/analytics"
require_rel "../../../support/graphql"
require_relative "../../../eurosports/pages/universal_page"
require_rel "../../../support/monkey_patches"
MonkeyPatches.include_patches

Support::EntryPoint.new.setup_single_workspace unless ENV["PRESERVE_WORKSPACE"]

require_all File.join(Support::Paths.es_root, "pages")

if ENV["LEGACY_BUILD"]
  ENV["BS_USER"] = ENV["BROWSERSTACK_USERNAME"]
  ENV["BS_KEY"] = ENV["BROWSERSTACK_ACCESS_KEY"]
  ENV["BS_IDENTIFIER"] = ENV["BROWSERSTACK_LOCAL_IDENTIFIER"]
  ENV["BS_BUILD"] = ENV["BROWSERSTACK_BUILD"]
end

ENV["SITE"] = ENV["SITE"].gsub('"', "")
ENV["PLATFORM"] = ENV["PLATFORM"].gsub('"', "") if ENV["PLATFORM"]

$base_url = "https://#{ENV['SERVER_LOGIN_ATV']}:#{ENV['SERVER_PASS_ATV']}@#{ENV['EUROSPORT_URL']}"
BROWSER = Support::Browser.new(PROFILE.browser)
MISC_SETTINGS = PROFILE.misc
BROWSER.start unless ENV["LOCAL_PROXY"] == "true"

MITM = MitmProxy.new if ENV["LOCAL_PROXY"] == "true"
#  This loads data for each of our network based off the ENV["SITE"] value.
#  This lets tests use NETWORK_DATA.show or NETWORK_DATA.network_code etc.
NETWORK_DATA = PageHelpers::NetworkDataHelper.new

ENV["ANALYTICAL_DATA_PATH"] = File.join(Support::Paths.support, "analytics", "eurosports", "analytics_request_fields_data.json")
ANALYTICS = EuroAnalyticsExtraction.new

# graphql query path
ENV["GRAPHQL_QUERY_PATH"] = File.join(Support::Paths.support, "graphql", "graphql_queries.json")

GRAPHQL = GraphqlCommonPage.new

World(PageObject::PageFactory)

if ENV["HEADLESS"] == "true"
  require "headless"

  headless = Headless.new
  headless.start

  at_exit do
    headless.destroy
  end
end

# Test rail config
ENV["test_rail_config_path"] = File.join(File.dirname(__FILE__), "test_rail_config.json")

## TODO this is hacky and should be moved to support or a universal page
def eventually(options = {})
  timeout = options[:timeout] || 30
  interval = options[:interval] || 0.1
  time_limit = Time.now + timeout
  loop do
    begin
      yield # will be what's in the block, eg. eventually(timeout: 60) { expect(thing1).to eq thing2 }
    rescue RSpec::Expectations::ExpectationNotMetError,
           Watir::Wait::TimeoutError,
           Watir::Exception::UnknownObjectException,
           Selenium::WebDriver::Error::StaleElementReferenceError,
           JSON::ParserError,
           EOFError => e
     # rubocop:disable all
      puts e
      # rubocop:enable all
    end
    return if error.nil?
    raise error if Time.now >= time_limit

    # rubocop:disable Custom/SleepCop
    sleep interval
    # rubocop:enable Custom/SleepCop
  end
end

# rubocop:disable Style/GlobalStdStream
LOGGER = Logger.new(STDOUT)
# rubocop:enable Style/GlobalStdStream
