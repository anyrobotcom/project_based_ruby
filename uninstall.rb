#!/usr/bin/env ruby

system "cd launch && launchctl unload *.plist"
system "launchctl list | grep unirpa"
puts "UniRPA uninstalled!"