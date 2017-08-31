# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016-2017 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unobtainium-cucumber/version'

# rubocop:disable Style/UnneededPercentQ, Layout/ExtraSpacing
# rubocop:disable Layout/SpaceAroundOperators
Gem::Specification.new do |spec|
  spec.name          = "unobtainium-cucumber"
  spec.version       = Unobtainium::Cucumber::VERSION
  spec.authors       = ["Jens Finkhaeuser"]
  spec.email         = ["jens@finkhaeuser.de"]
  spec.description   = %q(
    The unobtainium-cucucmber gem adds some convenient cucumber specific hooks
    for use with unobtainium.
  )
  spec.summary       = %q(
    Cucumber hooks for unobtainium.
  )
  spec.homepage      = "https://github.com/jfinkhaeuser/unobtainium-cucumber"
  spec.license       = "MITNFA"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rubocop", "~> 0.49"
  spec.add_development_dependency "rake", "~> 11.3"
  spec.add_development_dependency "simplecov", "~> 0.13"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "appium_lib", ">= 9.1"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "chromedriver-helper"
  spec.add_development_dependency "phantomjs"

  spec.add_dependency "unobtainium", "~> 0.12"
  spec.add_dependency "unobtainium-multifind", "~> 0.3"
  spec.add_dependency "unobtainium-multiwait", "~> 0.2"
  spec.add_dependency "cucumber", "~> 2.0"
  spec.add_dependency "octiron", "~> 0.5"
end
# rubocop:enable Layout/SpaceAroundOperators
# rubocop:enable Style/UnneededPercentQ, Layout/ExtraSpacing
