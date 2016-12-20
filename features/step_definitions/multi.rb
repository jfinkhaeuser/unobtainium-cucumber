# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

Given(/^I have a driver$/) do
  if driver.nil?
    raise "No driver found!"
  end
end

Then(/^I expect it to respond to "([^"]*)"$/) do |methname|
  if not driver.respond_to?(methname.to_sym)
    raise "Driver does not respond to '#{methname}'!"
  end
end
