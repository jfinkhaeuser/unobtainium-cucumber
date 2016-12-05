# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

require 'unobtainium-cucumber/action/screenshot'
require 'unobtainium-cucumber/action/content'
require_relative './mocks/scenario'

Given(/^I take a screenshot$/) do
  tester = Class.new { extend ::Unobtainium::Cucumber::Action }
  tester.store_screenshot(self, MockScenario.new('screenshots'))
end

Then(/^I expect there to be a matching screenshot file$/) do
  # The expectation is that the file starts with an ISO8601 timestamp of today
  # and ends in 'screenshots.png'. The part we can't be certain about is the
  # exact time stamp, because seconds, minutes, etc. even years could have
  # rolled over between taking the screenshot and finding it.

  # So what we do instead is find files that match the end. If the start matches
  # the syntax of a timestamp string, we can convert it to a timestamp. Then we
  # can find out if between said timestamp and right now only a few seconds elapsed.
  # If we find one such file, the test succeeds.
  pattern = 'screenshots/*-screenshots.png'
  timeout_match_files(pattern)

  # *After* all checks, remove matching files.
  FileUtils.rm(Dir.glob(pattern))
end

Given(/^I navigate to the best site in the world$/) do
  driver.navigate.to 'http://finkhaeuser.de'
end

When(/^I capture the page content$/) do
  # See the similar screnshot matching step for some details.
  tester = Class.new { extend ::Unobtainium::Cucumber::Action }
  tester.store_content(self, MockScenario.new('contents'))
end

Then(/^I expect there to be a matching content file$/) do
  # See the similar screnshot matching step for some details.
  pattern = 'content/*-contents.txt'
  match_file = timeout_match_files(pattern)

  # Check that some expected content exists.
  match = File.open(match_file).grep(/<html/)
  if match.empty?
    raise "File content of '#{match_file}' does not seem to be valid HTML!"
  end

  # *After* all checks, remove matching files.
  FileUtils.rm(Dir.glob(pattern))
end

