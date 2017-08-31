# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016-2017 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

After do |_|
  if not driver.respond_to? :reset
    next
  end

  # Covering this would require two separate test suites. I'm not sure I'm
  # ready for that.
  # :nocov:
  if config['cucumber.driver_reset'] == false
    next
  end
  # :nocov:

  begin
    driver.reset
  rescue => error
    # :nocov:
    # If driver reset isn't possible, it doesn't make sense to continue
    puts "DRIVER RESET WASN'T POSSIBLE DUE TO #{error} - BUT IS REQUIRED "\
         "FOR BEFORE NEXT SCENARIO. WILL EXIT THE PROGRAM"
    driver.quit
    Kernel.exit(2)
    # :nocov:
  end
end
