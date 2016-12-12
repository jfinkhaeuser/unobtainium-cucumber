# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

# Test handler for Octiron events
class OctironHandler
  def initialize
    @called = false
  end

  attr_reader :called

  def call(_event, *_args)
    @called = true
  end
end

Given(/^I register a handler for AfterTestStep$/) do
  @handler = OctironHandler.new
  on_event(::Cucumber::Events::AfterTestStep, @handler)
end

Then(/^I expect that handler to be fired$/) do
  if not @handler.called
    raise "Handler was not called!"
  end
end
