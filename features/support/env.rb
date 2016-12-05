# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

# Code coverage first
require 'simplecov'
SimpleCov.start do
  add_filter 'features'
end

# Other requires after SimpleCov
require "unobtainium-cucumber"

# Extensions used for testing
module MyExtensions
  def method_from_own_extension(*args, &block)
  end
end # module MyExtensions

World(MyExtensions)

# Utility code for testing
require_relative './utils'
