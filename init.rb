# frozen_string_literal: true

folders = 'config, controllers, services'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
