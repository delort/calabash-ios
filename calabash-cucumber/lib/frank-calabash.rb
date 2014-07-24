# stubs for documentation
require 'calabash-cucumber/core'
require 'calabash-cucumber/operations'
require 'calabash-cucumber/launcher'

# base module for Frank-Calabash
module Calabash
  module Cucumber
    module Map
      def raw_map(query, method_name, *method_args)
        operation_map = {
            :method_name => method_name,
            :arguments => method_args
        }
        res = http({:method => :post, :path => 'cal_map'},
                   {:query => query, :operation => operation_map})
        res = JSON.parse(res)
        if res['outcome'] != 'SUCCESS'
          screenshot_and_raise "map #{query}, #{method_name} failed because: #{res['reason']}\n#{res['details']}"
        end

        res
      end

    end
  end
end

module Frank
  module Calabash

    def launch(options={})
      launcher = ::Calabash::Cucumber::Launcher.launcher
      #noinspection RubyResolve
      options[:app] ||= File.expand_path('Frank/frankified_build/Frankified.app')
      ::Frank::Cucumber::FrankHelper.selector_engine = 'calabash_uispec'

      launcher.relaunch(options)
    end

    module Operations
      include ::Calabash::Cucumber::Operations
      alias_method :touch_cal, :touch


      def touch(uiquery)
        query_result = frankly_map(uiquery,:query).first
        unless query_result
          raise "could not find anything matching [#{uiquery}] to touch"
        else
          touch_cal(query_result)
        end
      end

    end
  end
end