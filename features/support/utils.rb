# coding: utf-8
#
# unobtainium-cucumber
# https://github.com/jfinkhaeuser/unobtainium-cucumber
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-cucumber
# contributors. All rights reserved.
#

TIMESTAMP_REGEX ||= /\d{4}_\d{2}_\d{2}T\d{2}_\d{2}_\d{2}Z/

##
# Given a file name, extrat and convert timestamps
def timestamp_from_filename(filename)
  # First, check if we can find the file name matching a timestamp
  parts = File.split(filename)
  parts = parts[-1].split('-')
  timestamp = parts[0]
  if not TIMESTAMP_REGEX.match(timestamp)
    return
  end

  # Great, then fix the formatting...
  timestamp[4] = '-'
  timestamp[7] = '-'
  timestamp[13] = ':'
  timestamp[16] = ':'

  return Time.parse(timestamp)
end

##
# Given a match pattern and optional timeout, finds files matching the pattern
# that have been created within the given timeout from now.
def timeout_match_files(pattern, timeout = 5)
  now = Time.now.utc

  Dir[pattern].each do |fname|
    ts = timestamp_from_filename(fname)
    if (now - ts).abs <= timeout
      return fname
    end
  end

  raise "No file matching '#{pattern}' with a timestamp in the last #{timeout} "\
    "seconds was found!"
end
