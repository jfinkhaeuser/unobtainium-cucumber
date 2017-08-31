# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016-2017 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

# Code coverage first
require 'simplecov'
SimpleCov.start do
  add_filter 'features'
end

# Other requires after SimpleCov
require "unobtainium-cucumber"
require "unobtainium-cucumber/octiron_events"

# Extensions used for testing
module MyExtensions
  def method_from_own_extension(*args, &block); end
end # module MyExtensions

World(MyExtensions, Octiron::World)

# Utility code for testing
require_relative './utils'
