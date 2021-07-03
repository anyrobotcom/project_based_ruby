#!/usr/bin/env ruby -W0

# frozen_string_literal: true

$enable_browser = true

require_relative "../../lib/boot"

browser_go "https://www.whatismyip.com/user-agent-info/"
puts "Your full setup details (your 'user agent string'): #{browser_text(:h5, { class: 'card-title' } )}"
$browser.close