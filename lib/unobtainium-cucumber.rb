# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

require 'unobtainium'
require 'unobtainium-cucumber/version'

# First things first: extend the World. Otherwise nothing in this file will
# work.
World(Unobtainium::World)

require 'unobtainium-cucumber/driver_reset.rb'
require 'unobtainium-cucumber/status_actions.rb'

World(Unobtainium::Cucumber::StatusActions)
