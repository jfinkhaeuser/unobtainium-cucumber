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

module Unobtainium
  module Cucumber
    ##
    # The StatusActions module contains all functionality for registering
    # actions to be run when a scenario or outline ended with a particular
    # status.
    module StatusActions
      # Key for storing actions in unobtainium's runtime instance.
      RUNTIME_KEY = 'unobtainium-cucumber-status-actions'.freeze

      ##
      # Register a action for a :passed? or :failed? scenario.
      # The :type parameter may either be :scenario or :outline.
      # The action will be passed the matching scenario. If no
      # explicit action is given, a block is also acceptable.
      def register_action(status, action = nil, options = nil, &block)
        # If the action is a Hash, then the options should be nil. If that's
        # the case, we have no action and instead got passed options.
        if action.is_a? Hash
          if not options.nil?
            raise "Can't pass a Hash as an action!"
          end
          options = action
          action = nil
        end

        # Parameter checks!
        if not [:passed?, :failed?].include?(status)
          raise "Status may be one of :passed? or :failed? only!"
        end

        options ||= {}
        type = options[:type] || :scenario
        if not [:scenario, :outline].include?(type)
          raise "The :type option may be one of :scenario or :outline only!"
        end

        if action.nil? and block.nil?
          raise "Must provide either an action method or a block!"
        end
        if not action.nil? and not block.nil?
          raise "Cannot provide both an action method and a block!"
        end

        callback = action || block

        # The key to store callbacks under is comprised of the status
        # and the type. That way we can match precisely when actions are to
        # be executed.
        key = [status, type]

        # Retrieve existing actions
        actions = {}
        if ::Unobtainium::Runtime.instance.has?(RUNTIME_KEY)
          actions = ::Unobtainium::Runtime.instance.fetch(RUNTIME_KEY)
        end

        # Add the callback
        actions[key] ||= []
        actions[key] |= [callback]

        # And store the callback actions again.
        ::Unobtainium::Runtime.instance.store(RUNTIME_KEY, actions)
      end

      ##
      # For a given scenario, return the matching key for the actions.
      def action_key(scenario)
        return [
          (scenario.passed? ? :passed? : :failed?),
          (scenario.outline? ? :outline : :scenario)
        ]
      end

      ##
      # Automatically register all configured status actions.
      # This is largely an internal function, run after the first scenario
      # and before status actions are executed.
      def register_config_actions(world)
        to_register = world.config['cucumber.status_actions'] || {}

        [:passed?, :failed?].each do |status|
          for_status = to_register[status]
          if for_status.nil?
            # :nocov:
            next
            # :nocov:
          end

          # If the entry for the status is an Array, it applies to scenarios
          # and outlines equally. Otherwise we'll have to find a Hash with
          # entries for either or both.
          actions = {}
          if for_status.is_a?(Array)
            actions[:scenario] = for_status
            actions[:outline] = for_status
          elsif for_status.is_a?(Hash)
            actions[:scenario] = for_status[:scenario] || []
            actions[:outline] = for_status[:outline] || []
          else
            # :nocov:
            raise "Cannot interpret status action configuration for status "\
              "#{status}; it should be an Array or Hash, but instead it was"\
              " this: #{for_status}"
            # :nocov:
          end

          # Now we have actions for the statuses, we can register them.
          [:scenario, :outline].each do |type|
            actions[type].each do |action|
              register_action(status, action, type: type)
            end
          end
        end
      end

      ##
      # Given an action and a scenario, execute the action. This includes
      # late/lazy resolution of String or Symbol actions.
      def execute_action(world, action, scenario)
        # Simplest case first: the action is already callable.
        if action.respond_to?(:call)
          return action.call(world, scenario)
        end

        # Symbols are almost as easy to handle: they must resolve to a
        # method, either globally or on the world object.
        if action.is_a? Symbol
          meth = resolve_action(Object, world, action)
          if meth.nil?
            raise NoMethodError, "Symbol :#{action} could not be resolved "\
              "either globally or as part of the cucumber World object, "\
              "aborting!"
          end
          return meth.call(world, scenario)
        end

        # At this point, the action better be a String.
        if not action.is_a? String
          raise "Action '#{action}' is not callable, and not a method name. "\
            "Aborting!"
        end

        # Split module and method name
        module_name, method_name = split_string_action(action)

        # If we have no discernable module, use Object instead.
        the_module = Object
        if not module_name.nil? and not module_name.empty?
          the_module = Object.const_get(module_name)
        end

        # Try the module we found (i.e. possibly Object) and world for
        # resolving the method name.
        meth = resolve_action(the_module, world, method_name)
        if meth.nil?
          raise NoMethodError, "Action '#{action}' could not be resolved!"
        end

        return meth.call(world, scenario)
      end

      ##
      # For a given status and type, return the registered actions.
      def registered_actions(status, type)
        if not ::Unobtainium::Runtime.instance.has?(RUNTIME_KEY)
          return []
        end

        actions = ::Unobtainium::Runtime.instance.fetch(RUNTIME_KEY)
        return actions[[status, type]] || []
      end

      ##
      # Partially for testing purposes, clears the action registry.
      def clear_actions
        if not ::Unobtainium::Runtime.instance.has?(RUNTIME_KEY)
          # :nocov:
          return
          # :nocov:
        end

        ::Unobtainium::Runtime.instance.delete(RUNTIME_KEY)
      end

      ##
      # Resolves the given symbol in either of the given namespace or the
      # world object. Returns nil if neither contained the symbol.
      def resolve_action(namespace, world, method_name)
        method_sym = method_name.to_sym

        [namespace, world].each do |receiver|
          begin
            return receiver.method(method_sym)
          rescue NameError
            next
          end
        end
        return nil
      end

      ##
      # Splits a string action into a module prefix and a method name
      def split_string_action(action)
        # Try to see whether we have a fully qualified name that requires us
        # to query a particular module for the method.
        split_action = action.split(/::/)
        method_name = split_action.pop

        # If the method name contains a dot, it uses 'Module.method' notation.
        # rubocop:disable Lint/EmptyWhen
        split_method = method_name.split(/\./)
        case split_method.length
        when 1
          # Do nothing; the method name did not contain a dot
        when 2
          # We have a method name and a module part
          split_action << split_method[0]
          method_name = split_method[1]
        else
          raise "Too many dots in method name: #{method_name}"
        end
        # rubocop:enable Lint/EmptyWhen

        # Re-join the module name
        module_name = split_action.join('::')

        return module_name, method_name
      end
    end # module StatusActions
  end # module Cucumber
end # module Unobtainium

##
# The After hook with cucumber defined here will register config actions
# and execute all matching, registered actions.
After do |scenario|
  # Register all configured actions.
  register_config_actions(self)

  # Fetch actions applying to this scenario
  key = action_key(scenario)
  applicable_actions = registered_actions(key[0], key[1])

  # Execute all actions applying to this scenario
  applicable_actions.each do |action|
    execute_action(self, action, scenario)
  end
end
