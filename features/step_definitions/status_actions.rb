# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

class StatusActionsTester
  # Include StatusActions functionality...
  include ::Unobtainium::Cucumber::StatusActions

  # ... but also double as scenario
  def passed?
    return @passed
  end

  def outline?
    return @outline
  end

  # Also, add setters for the above.
  def passed=(value)
    @passed = value
  end

  def outline=(value)
    @outline = value
  end
end

Given(/^I have a test instance of the StatusActions module$/) do
  @status_actions = StatusActionsTester.new
  @status_actions.clear_actions
end

Given(/^I have a scenario which has (passed|failed)$/) do |result|
  @status_actions.passed = result == 'passed' ? true : false
end

Given(/^the scenario is( not)? an outline$/) do |negation|
  @status_actions.outline = negation.nil? ? true : false
end

Then(/^I expect the output to contain :(passed\?|failed\?) and :(scenario|outline)$/) do |status, type|
  # Since the status action instance behaves as a scenario from the previous
  # steps, we can pass it to the action_key method.
  result = @status_actions.action_key(@status_actions)

  expectation = [status.to_sym, type.to_sym]
  if result != expectation
    raise "Got '#{result}' but expected '#{expectation}'!"
  end
end
