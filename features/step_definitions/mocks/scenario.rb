# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

##
# A mock scenario has a name
class MockScenario
  def initialize(name)
    @name = name
  end

  attr_reader :name
end



