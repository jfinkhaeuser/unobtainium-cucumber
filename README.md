# unobtainium-cucumber
*Cucumber specific extensions to unobtainium.*

Instead of requiring [unobtainium](https://github.com/jfinkhaeuser/unobtainium)
in your [cucumber](https://cucumber.io/) project, just require this gem. It'll
automatically some cucumber specific features to your project:

- Reset the driver after each scenario.
- Take screenshots on failures.

Of course, each of these can be configured.

[![Gem Version](https://badge.fury.io/rb/unobtainium-cucumber.svg)](https://badge.fury.io/rb/unobtainium-cucumber)
[![Build status](https://travis-ci.org/jfinkhaeuser/unobtainium-cucumber.svg?branch=master)](https://travis-ci.org/jfinkhaeuser/unobtainium-cucumber)
[![Code Climate](https://codeclimate.com/github/jfinkhaeuser/unobtainium-cucumber/badges/gpa.svg)](https://codeclimate.com/github/jfinkhaeuser/unobtainium-cucumber)
[![Test Coverage](https://codeclimate.com/github/jfinkhaeuser/unobtainium-cucumber/badges/coverage.svg)](https://codeclimate.com/github/jfinkhaeuser/unobtainium-cucumber/coverage)

# Usage

The project's own *cucumber*-based test suite demonstrates most of the details.

In brief, all the setup happens in the `features/support/env.rb` file:

```ruby
require "unobtainium-cucumber"
```

TBD
