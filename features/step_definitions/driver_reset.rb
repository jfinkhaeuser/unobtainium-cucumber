# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

# rubocop:disable Style/GlobalVars
$reset_called = 0

Given(/^I remove any reset functions$/) do
  driver.class.class_eval do
    # rubocop:disable Lint/HandleExceptions
    begin
      remove_method :reset
    rescue NameError
    end
    # rubocop:enable Lint/HandleExceptions
  end
end

Given(/^I run a scenario to test driver reset$/) do
  # We decorate the driver class with a 'reset' method for two reasons:
  # a) we can this way track that it was called, and
  # b) we work around the fact that not all drivers support the 'reset'
  #    function.
  driver.class.class_eval do
    def reset(*args)
      $reset_called += 1
      # rubocop:disable Lint/HandleExceptions
      begin
        super(*args)
      rescue NoMethodError
        # Work around drivers not supporting reset
      end
      # rubocop:enable Lint/HandleExceptions
    end
  end
end

Then(/^the driver should be reset at the end$/) do
  # Absolutely nothing to do here; but see $reset_called
end

Given(/^I run a scenario with a driver that knowns no reset$/) do
  # Instanciate the driver by looking at its class.
  driver.class
end

Then(/^the driver should not be reset at the end$/) do
  # Absolutely nothing to do here; but see $reset_called
end

at_exit do
  # We expect reset to be called exactly once, for the driver that defines
  # such a function.
  if not $reset_called == 1
    warn '*' * 80
    warn "* If this fails, check the steps in 'driver_reset.feature'!"
    warn '*' * 80
    Kernel.exit(3)
  end
end

# rubocop:enable Style/GlobalVars
