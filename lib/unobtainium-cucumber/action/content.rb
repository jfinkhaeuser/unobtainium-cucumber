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
      # Status action function that stores the page content (main page only)
      def store_content(world, scenario)
        # Make sure the content directory exists.
        basedir = File.join(Dir.pwd, 'content')
        FileUtils.mkdir_p(basedir)

        # Store content. Note that not all drivers may support this.
        filename = File.join(basedir, base_filename(scenario))
        filename += '.txt'

        File.open(filename, 'w') do |file|
          file.write(world.driver.page_source)
        end
      end
    end # module Action
  end # module Cucumber
end # module Unobtainium
