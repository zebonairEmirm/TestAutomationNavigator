require "selenium-webdriver"
require "watir"
require "rspec"
 
Credentials={ #Credentials I will use for login
 email: "oiikwpe_bharambewitz_1581674409@tfbnw.net", 
 password: "vqw6tpy2jd1" 
 }

describe 'Facebook' do
    test_site="https://www.facebook.com/"
    browser=Watir::Browser.new :chrome
    browser.goto test_site

    it 'Logs into facebook' do
        browser.text_field(:id, "email").set Credentials[:email]
        browser.text_field(:id, "pass").set Credentials[:password]
        browser.button(:type,"submit").click
    end

    it 'Verifies the user' do
        if expect {browser.text.include? 'John'} #Checks the username in the navigation
            puts "Login Verified"
        else
            puts "Error While Verifying Login"
        end
    end

end
 


