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
  # Not all classes in the namespace may be events - but it's better to try
  # a few too many than to have to constantly update this file when Cucumber
  # changes.
  ::Cucumber::Events.constants.each do |const|
    event_type = ::Cucumber::Events.const_get(const)
    if not event_type.is_a? Class
      next
    end
    config.on_event(event_type) do |event|
      ::Octiron::World.event_bus.publish(event)
    end
  end
end
