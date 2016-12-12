# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

require 'octiron'
require 'cucumber'

AfterConfiguration do |config|
  # Register handlers for all Cucumber events on cucumber's event bus.
  CUKE_EVENTS ||= [
    :after_test_case,
    :after_test_step,
    :before_test_case,
    :before_test_step,
    :finished_testing,
    :step_match
  ].freeze

  CUKE_EVENTS.each do |event_name|
    config.on_event(event_name) do |event|
      ::Octiron::World.event_bus.publish(event)
    end
  end
end
