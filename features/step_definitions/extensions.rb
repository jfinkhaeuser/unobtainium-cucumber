# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

Given(/^I register an extension with cucumber's World$/) do
  # There's nothing to do here. The extension is registered in
  # features/support/env.rb as it should be.
end

Then(/^I expect this extension to be used$/) do
  # Calling the method should already fail, so no need for testing whether
  # the method is callable :)
  method_from_own_extension
end
