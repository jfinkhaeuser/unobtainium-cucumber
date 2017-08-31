# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016-2017 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

# rubocop:disable Style/GlobalVars

def dummy_action(*_); end

def global_action(*_); end

$counter = 0
def counting_action(*_)
  $counter += 1
end

def recording_action(_, scenario)
  scenario.called = true
end

# TestModule
module TestModule
  def self.inner_recorder(*args)
    recording_action(*args)
  end
end

# StatusActionsTester doubles both as a test target for the actions, a
# state crossing multiple step definitions, and behaving a bit like
# a scenario.
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
  attr_writer :passed
  attr_writer :outline

  # Accessors for various test states
  attr_accessor :register_status
  attr_accessor :register_type
  attr_accessor :register_functions

  attr_accessor :exception

  attr_accessor :called
end

Given(/^I have a test instance of the StatusActions module$/) do
  @status_actions = StatusActionsTester.new
end

Then(/^I want to clear configured actions$/) do
  @status_actions.clear_actions
end

Given(/^I have a scenario which has (passed|failed)$/) do |result|
  @status_actions.passed = result == 'passed' ? true : false
end

Given(/^the scenario is( not)? an outline$/) do |negation|
  @status_actions.outline = negation.nil? ? true : false
end

Then(
  /^I expect the output to contain :(passed\?|failed\?) and :(scenario|outline)$/
) do |status, type|
  # Since the status action instance behaves as a scenario from the previous
  # steps, we can pass it to the action_key method.
  result = @status_actions.action_key(@status_actions)

  expectation = [status.to_sym, type.to_sym]
  if result != expectation
    raise "Got '#{result}' but expected '#{expectation}'!"
  end
end

Given(/^I try to register an action for status (.*)$/) do |status|
  @status_actions.register_status = status.strip
  @status_actions.register_type = :scenario # valid
  @status_actions.register_functions = [:dummy_action, nil] # valid
end

Given(/^I try to register an action for the type (.*)$/) do |type|
  @status_actions.register_status = :passed? # valid
  @status_actions.register_type = type.strip
  @status_actions.register_functions = [:dummy_action, nil] # valid
end

Given(/^I try to register no action$/) do
  @status_actions.register_status = :passed? # valid
  @status_actions.register_type = :scenario # valid
  @status_actions.register_functions = [nil, nil]
end

Given(/^I try to register two actions$/) do
  @status_actions.register_status = :passed? # valid
  @status_actions.register_type = :scenario # valid
  @status_actions.register_functions = [:dummy_action, proc { |*args| }]
end

Then(/^I expect the function to (.+)$/) do |result|
  result.strip!

  status_sym = @status_actions.register_status.to_sym
  type_sym = @status_actions.register_type.to_sym
  action_func = @status_actions.register_functions[0]
  action_block = @status_actions.register_functions[1]

  begin
    @status_actions.register_action(status_sym, action_func, type: type_sym,
                                    &action_block)
  rescue RuntimeError => err
    if result == 'succeed'
      raise err
    end
  else
    if result == 'fail'
      raise "Expected this to fail, but it didn't!"
    end
  end
end

Given(/^I register no action, but provide options$/) do
  # We'll perform the call, and record if there was an exception
  begin
    @status_actions.register_action(:passed?, type: :scenario)
  rescue RuntimeError => err
    @status_actions.exception = err
  else
    @status_actions.exception = nil
  end
end

Given(/^I register a Hash as an action$/) do
  # We'll perform the call, and record if there was an exception
  begin
    # Note that this is possible to do, but shouldn't happen. Normally
    # if you pass a Hash as the second parmeter, you'd expect that to be
    # the options, and a block to be provided.
    @status_actions.register_action(:passed?, {}, {})
  rescue RuntimeError => err
    @status_actions.exception = err
  else
    @status_actions.exception = nil
  end
end

Then(/^I expect the there to be an error$/) do
  # Named differently from "the function to fail" because the above step would
  # get far too complex.

  # We expect an exception to be recorded, and if there is none, we fail
  if @status_actions.exception.nil?
    raise "Expected this to fail, but it didn't!"
  end
end

Given(/^I register an action$/) do
  @status_actions.register_action(:passed?, :dummy_action)
end

When(/^I register another action$/) do
  @status_actions.register_action(:passed?) do |*args|
  end
end

Then(/^I expect there to be two registered actions$/) do
  # The default type is :scenario
  registered = @status_actions.registered_actions(:passed?, :scenario)
  if registered.length != 2
    raise "Expected two registered actions, but found: #{registered.lenght}"
  end
end

Given(/^I have registered no actions$/) do
  # Not doing anything here!
end

Then(/^I expect there to be no registered actions$/) do
  # The default type is :scenario
  registered = @status_actions.registered_actions(:passed?, :scenario)
  if not registered.empty?
    raise "Expected zero registered actions, but found: #{registered.lenght}"
  end
end

Given(/^I have registered an action$/) do
  @status_actions.register_action(:passed?, :counting_action)
end

Then(/^I expect it to be executed$/) do
  # Nothing to do; see at_exit below
end

Given(/^I register configured actions$/) do
  # Configured actions should be registered automatically; that's hard to
  # test here. However, see the background step!
  # Let's just register them again!
  register_config_actions(self)
end

Then(/^I expect all configured actions to be present$/) do
  registered = @status_actions.registered_actions(:passed?, :scenario)
  if not registered.include?('global_action')
    raise "Expected 'global_action' in #{registered}!"
  end

  registered = @status_actions.registered_actions(:passed?, :outline)
  if not registered.include?('global_action')
    raise "Expected 'global_action' in #{registered}!"
  end

  registered = @status_actions.registered_actions(:failed?, :scenario)
  if not registered.include?('method_from_own_extension')
    raise "Expected 'global_action' in #{registered}!"
  end

  registered = @status_actions.registered_actions(:failed?, :outline)
  if not registered.include?('dummy_action')
    raise "Expected 'global_action' in #{registered}!"
  end
end

Then(/^I expect only configured actions to be present$/) do
  registered = @status_actions.registered_actions(:passed?, :scenario)
  if registered != %w[global_action]
    raise "Expected different actions than #{registered}!"
  end

  registered = @status_actions.registered_actions(:passed?, :outline)
  if registered != %w[global_action]
    raise "Expected different actions than #{registered}!"
  end

  registered = @status_actions.registered_actions(:failed?, :scenario)
  if registered != %w[method_from_own_extension]
    raise "Expected different actions than #{registered}!"
  end

  registered = @status_actions.registered_actions(:failed?, :outline)
  if registered != %w[dummy_action]
    raise "Expected different actions than #{registered}!"
  end
end

Given(/^I execute a method action$/) do
  @status_actions.called = false
  @status_actions.execute_action(self, method(:recording_action), @status_actions)
end

Then(/^I expect this to succeed$/) do
  if not @status_actions.called
    raise "Expected the action to be invoked, but it wasn't!"
  end
end

Given(/^I execute a block action$/) do
  action = proc do |_, scenario|
    scenario.called = true
  end

  @status_actions.called = false
  @status_actions.execute_action(self, action, @status_actions)
end

Given(/^I execute a symbol action$/) do
  @status_actions.called = false
  @status_actions.execute_action(self, :recording_action, @status_actions)
end

Given(/^I execute a string action$/) do
  @status_actions.called = false
  @status_actions.execute_action(self, 'recording_action', @status_actions)
end

Given(/^I execute a namespaced string action$/) do
  @status_actions.called = false
  @status_actions.execute_action(self, '::TestModule::inner_recorder',
                                 @status_actions)
end

Given(/^I execute a namespaced string action that is dot\-separated$/) do
  @status_actions.called = false
  @status_actions.execute_action(self, '::TestModule.inner_recorder',
                                 @status_actions)
end

Given(/^I execute string action that does not resolve$/) do
  @status_actions.called = false
  # rubocop:disable Lint/HandleExceptions
  begin
    @status_actions.execute_action(self, 'does not resolve', @status_actions)
  rescue => _err
  end
  # rubocop:enable Lint/HandleExceptions
end

Given(/^I execute symbol action that does not resolve$/) do
  @status_actions.called = false
  # rubocop:disable Lint/HandleExceptions
  begin
    @status_actions.execute_action(self, :does_not_resolve, @status_actions)
  rescue => _err
  end
  # rubocop:enable Lint/HandleExceptions
end

Given(/^I execute string action with two dots$/) do
  @status_actions.called = false
  # rubocop:disable Lint/HandleExceptions
  begin
    @status_actions.execute_action(self, 'can.not.resolve', @status_actions)
  rescue => _err
  end
  # rubocop:enable Lint/HandleExceptions
end

Given(/^I execute a number action$/) do
  @status_actions.called = false
  # rubocop:disable Lint/HandleExceptions
  begin
    @status_actions.execute_action(self, 42, @status_actions)
  rescue => _err
  end
  # rubocop:enable Lint/HandleExceptions
end

Then(/^I expect this to fail$/) do
  if @status_actions.called
    raise "Expected the action not to be invoked, but it was!"
  end
end

at_exit do
  # We expect the counting_action to be called once.
  if $counter < 1
    warn '*' * 80
    warn "* If this fails, check the steps in 'status_actions.feature'!"
    warn '*' * 80
    Kernel.exit(4)
  end
end

# rubocop:enable Style/GlobalVars
