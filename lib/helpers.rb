# frozen_string_literal: true

# ------------------------------ Monkey Patches

# Helper for inflections
class Symbol
  def pluralize
    to_s.concat('s').to_sym
  end
end

# ------------------------------ Development

# Reloads environment (often used in development / binding.pry)
def reload!
  # Load config once again
  $config = YAML.load_file("#{$root_directory}/config/config.yml") # Config
  # Load models
  Dir.glob("#{$root_directory}/models/*.rb").each do |file|
    load file
  end
  # Load services
  Dir.glob("#{$root_directory}/services/*.rb").each do |file|
    load file
  end
  # Load skills
  Dir.glob("#{$root_directory}/skills/*.rb").each do |file|
    load file
  end
  # Load helpers
  load "#{$root_directory}/lib/helpers.rb" # Helpers
  puts "Environment reloaded!"
end

# ------------------------------ Templates

# Render template to file
# Usage:
#   render_template('dupa.erb', { name: 'Janusz' })
def render_template(file_name, variables = {})
  ERB.new(
    File.read(
      "../templates/#{file_name}"
    )
  ).result(variables)
end

# ------------------------------ Communication

# Send sms to numbers in configs from Superb
# Usage:
#   send_sms('Done!')
def send_sms(text)
  client = Smsapi::Client.new($config["smsapi"]["token"])
  bulk = client.send_bulk(
    $config["smsapi"]["recipients"],
    text,
    from: $config["smsapi"]["sender"],
  )
  bulk.sent.count
end

# Send Pushover message
# Usage:
#   send_pushover('Done!')
def send_pushover(text)
  Pushover::Message.new(
    token: $config["pushover"]["api_token"],
    user: $config["pushover"]["user_key"],
    message: text,
  ).push
end

# Send both sms and push message
# Usage:
#   send_alert('Done!')
def send_alert(text)
  sms(text) && pushover(text)
end

# Send email to recipient
# Usage:
#   send_email(
#     from: 'bob@example.com',
#     to:   ['sally@example.com', 'ally@example.com'],
#     subject: 'AnyRobot is awesome!',
#     text: 'It is really easy to send a message!'
#   )
def send_email(options = {})
  mailgun = Mailgun::Client.new($config["mailgun"]["api_key"], $config["mailgun"]["server"])
  mailgun.send_message($config["mailgun"]["domain"], options).to_h!
end

# Send notification to Rocket.Chat channel
# Usage:
#   send_rocket_chat(
#     channel: "#general",
#     text: "Lorem Ipsum Dolor Amet",
#     alias: "TestBOT",
#     emoji: ":money_mouth:",
#     avatar: "https://www.icons.com/icon.png",
#     attachments: [
#       { image: "https://www.icons.com/icon_1.png" },
#       { image: "../local/file/location.png" },
#     ]
#   )
def send_rocket_chat(options = {})
  # Prepare attachments payload (if any)
  prepared_attachments = []
  if options.has_key?(:attachments)
    options[:attachments].each do |attachment|
      if URI::regexp(%w(http https)).match?(attachment[:image])
        # Valid url? Use it...
        prepared_attachments << { image_url: attachment[:image] }
      else
        # Not url? Upload file...
        prepared_attachments << { 
          image_url: `curl --upload-file #{attachment[:image]} https://transfer.sh/#{SecureRandom.hex(32)}.#{attachment[:image].split('.')[-1]}`
        }
      end
    end
  end
  # Authorize if needed
  # TODO: OAuth 2.0 here
  # Post to Rocket.Chat
  HTTParty.post(
    "#{$config["rocket_chat"]["server"]}/api/v1/chat.postMessage",
    headers: {
      "X-Auth-Token": $config["rocket_chat"]["x_auth_token"],
      "X-User-Id": $config["rocket_chat"]["x_user_id"],
      "Content-Type": "application/json; charset=utf-8"
    },
    body: {
      channel: options[:channel],
      text: options[:text],
      alias: options[:alias],
      emoji: options[:emoji],
      avatar: options[:avatar],
      attachments: prepared_attachments
    }.to_json,
  )
end

# ------------------------------ BROWSER

# Usage:
#   browser_go(url)
def browser_go(url)
  $browser.goto url
end

# Usage:
#   browser_click(:button, { name: 'login' })
# Returns:
#  true - success
#  nil - element not found
def browser_click(symbol, selector = {})
  if $browser.send(symbol, selector).exist?
    $browser.send(symbol, selector).click
    return true
  else
    return nil
  end
end

# Usage:
#   browser_type(:text_field, { name: 'login' }, 'lorem@ipsum.pl')
# Returns:
#  element - success
#  nil - element not found
def browser_set(symbol, selector = {}, value)
  if $browser.send(symbol, selector).exist?
    return $browser.send(symbol, selector).set(value)
  else
    return nil
  end
end

# Usage:
#   browser_text(:div, { id: 'login' })
# Returns:
#  element - success
#  nil - element not found
def browser_text(symbol, selector = {})
  if $browser.send(symbol, selector).exist?
    return $browser.send(symbol, selector).text
  else
    return nil
  end
end

# Usage:
#   browser_attr(:div, { id: 'login' }, 'data-someting')
# Returns:
#  element - success
#  nil - element not found
def browser_attr(symbol, selector = {}, attribute)
  if $browser.send(symbol, selector).exist?
    return $browser.send(symbol, selector).attribute_value(attribute)
  else
    return nil
  end
end

# Usage:
#   browser_elements(:div, { class: 'panel' })
# Returns:
#  collection - matching elements
#  nil - matching elements not found
def browser_elements(symbol, selector = {})
  if $browser.send(symbol, selector).exist?
    return $browser.send(symbol.pluralize, selector)
  else
    return nil
  end
end

# Usage:
#   browser_elements_count(:div, { class: 'panel' })
# Returns:
#  number - count of matching elements
#  nil - matching elements not found
def browser_elements_count(symbol, selector = {})
  if $browser.send(symbol, selector).exist?
    return $browser.send(symbol.pluralize, selector).count
  else
    return nil
  end
end