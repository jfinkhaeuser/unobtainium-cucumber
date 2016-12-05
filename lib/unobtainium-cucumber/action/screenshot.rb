# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

require 'unobtainium-cucumber/action/support/naming'

module Unobtainium
  module Cucumber
    module Action

      include Support

      ##
      # Status action function that takes a screenshot.
      def store_screenshot(world, scenario)
        # Make sure the screenshots directory exists.
        basedir = File.join(Dir.pwd, 'screenshots')
        FileUtils.mkdir_p(basedir)

        # Take screenshot.
        filename = File.join(basedir, base_filename(scenario))
        filename += '.png'
        world.driver.save_screenshot(filename)
      end
    end # module Action
  end # module Cucumber
end # module Unobtainium
