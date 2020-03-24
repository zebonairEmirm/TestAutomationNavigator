require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/rspec'


Capybara.default_driver = :selenium_chrome
Capybara.ignore_hidden_elements = false 


RSpec.describe 'Navigator Smoke Test', type: :feature do
    before(:each) do
        page.driver.browser.manage.window.maximize
        visit 'https://www.navigator.ba/#/categories'
    end

    it 'Drags a marker' do 
        find('#ember566', visible: false).click #Create place option
        source = page.find('.leaflet-marker-draggable') #Define marker
        #target = page.find(:xpath, '/html/body/div[4]/div/div/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/img[19]')
        #source.drag_to(target)
        puts source.native.css_value('transform') #matrix
        #puts element
        sleep(10)
        execute_script("arguments[0].setAttribute('style', 'transform: translate3d(732px, 325px, 90px); z-index: 325;');", source)
        sleep(10)
        puts source.native.css_value('transform')
        find('.leaflet-control-zoom-out').click
        sleep(2)
        puts source.native.css_value('transform')
    end
end