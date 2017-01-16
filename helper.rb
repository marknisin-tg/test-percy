require "rspec/expectations"
require 'rspec-steps/monkeypatching'
require 'pry'  #how to use it - just put this line of code somewhere: puts current_url
# choose on which browser to run script
require './spec_helper_ch.rb' # Chrome browser testing



def root_path
  return 'http://localhost:9000/'
end

def keyclock_path
  return 'http://10.3.1.11:8080/auth/admin/'
end

def keyclock_console_admin_login
  if page.has_css?('#kc-container-wrapper')
    fill_in("username", :with => "admin")
    fill_in("password", :with => "1q2w3e4R")
    click_button "Log in"
  end
end

def user_login(usertype)
if page.has_no_css?('header')
  case usertype
    when 'admin_user'
      fill_in("username", :with => "admin@novus.io")
      fill_in("password", :with => "12345678")
      click_button "kc-login"
    when 'viewer_user'
      fill_in("username", :with => "viewer@novus.io")
      fill_in("password", :with => "12345678")
      click_button "kc-login"
    when 'editor_user'
      fill_in("username", :with => "editor@novus.io")
      fill_in("password", :with => "12345678")
      click_button "kc-login"
    end
  end
end

$account_name_new = Array.new(15){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
