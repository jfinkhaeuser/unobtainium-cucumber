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

# Usage

The project's own *cucumber*-based test suite demonstrates most of the details.

In brief, all the setup happens in the `features/support/env.rb` file:

```ruby
require "unobtainium-cucumber"
```

And that's it.

## Configuration

All configuration for this gem happens in the `config.yml` read in by
*unobtainium*. All configuration keys respected in this gem live under the
top-level `cucumber` key, i.e.:

```yaml
# config.yaml
cucumber:
  # this gem's keys go here
```

## Driver Reset

By default, the driver's `#reset` function is called after each scenario for
drivers that respond to such a function.

You can switch this off with the `cucumber.driver_reset` flag:

```yaml
# config.yaml
cucumber:
  driver_reset: false
```

- If the flag is `false`, driver reset is switched off.
- If the flag is undefined (i.e. `nil`) or any other value, driver reset is
  switched on. The recommended value to switch it on explicitly is, of course,
  `true`.

## Status Actions

One of the convenient features of this gem is that it allows you to cleanly
define callbacks for a particular scenario status.

It's an extension of the [After hook](https://github.com/cucumber/cucumber/wiki/Hooks)
that allows you to specify whether your callback is invoked after a `Scenario`
or `Scenario Outline` (or both), and only it has `#passed?` or is `#failed?`
(or both). Status actions thus are actions triggered by a scenario status.

Status actions can be any function or block that takes two arguments, the
cucumber [World](https://github.com/cucumber/cucumber/wiki/A-Whole-New-World)
object, and the scenario itself (for further querying).

You can register them by including the `StatusActions` module in `World`, and
then calling `#register_action`:

```ruby

World(StatusActions)

# ...

Given(/I foo/) do
  # Registers #some_func for passed scenarios and outlines
  register_action(:passed?, method(:some_func))

  # Limits registration to outlines
  register_action(:failed?, method(:some_func), type: :outline)

  # Registers a block
  register_action(:failed?) do |world, scenario|
    # ...
  end
end
```

There are a number of other methods in the `StatusActions` module that you
can use, but this is by far the most important.

### Configuration

Of course, the above is for programmatically adding actions. But `unobtainium`
is configuration driven, so it makes sense to configure status actions in this
gem:

```yaml
# config.yaml
cucumber:
  status_actions:
    passed?:
      - global_action
    failed?:
      outline:
        - dummy_action
      scenario:
        - method_from_own_extension
```

Note how you can either provide an `Array` of method names to a status key,
or further divide the status key into individual lists for outlines and
scenarios.

### Builtin Status Actions

There are not many status actions built into this gem, although that number
may rise. Currently, there is:

- `#store_screenshot` writes a browser screenshot to the `screenshots`
  directory.
- `#store_content` writes a dump of the page content to the `content`
  directory.

File names are timestamped, and include the scenario name. That should
make debugging a failed scenario easier.

If you do not configure any actions, the default is to take screenshots after
any failure.

### Custom Actions

As demonstrated earlier, custom actions are easy to define. If they are
resolvable before a scenario starts (i.e. files are appropriately required),
then you can configure them as string names in the configuration.

You can specify any method of the `World` object, so any from your own
exentsions to `World`. Alternatively, any function that is resolvable works.
You might have to use fully qualified names.

Custom actions have limited support facilities in the `Action::Support` module.
Check it out if you write your own.

### Cucumber Events

Cucumber provides an event bus which lets you register handlers for [cucumber's
own events](http://www.rubydoc.info/gems/cucumber/Cucumber/Events). While that
is going to be very helpful for hooking into the flow of execution, this gem
adds [octiron](https://github.com/jfinkhaeuser/octiron) for further event
processing, by publishing all cucumber events on octiron's event bus.

Require `unobtainium-cucumber` as before, but also require the event processing
code:

```ruby
# env.rb
require 'unobtainium-cucumber'
require 'unobtainium-cucumber/octiron_events'

World(Octiron::World)
```

You can now register transmogrifiers for any of the cucumber event classes,
and use the power of octiron's event processing pipeline.
