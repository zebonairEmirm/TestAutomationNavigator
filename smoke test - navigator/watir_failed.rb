require 'rspec'
require 'watir'
require 'selenium-webdriver'


#initializing the browser
browser = Watir::Browser.new :chrome

#defining test
RSpec.describe 'Navigator Smoke' do 
    before(:all) do  #defining before block that runs once before all of the examples in a test                                             
        browser.goto 'https://www.navigator.ba/#/categories' #navigating to page /*[@id="ember622"]
    end

    it 'Creates a place' do 
        
        browser.ul(class: 'navigation').li(text: 'Kreiraj objekat').click   #locates and click 'Create place' option

        #filling out the form
        puts browser.text_field(id: 'place_tags').exists?
        browser.text_field(id: 'poi_name').set 'In Flames'
        browser.text_field(id: 'poi_city_name').set 'Sarajevo'
        browser.text_field(id: 'poi_zip_code').set '71 000'
        browser.text_field(id: 'poi_place_id').set 'Emila Zole'
        browser.text_field(id: 'poi_house_number').set '16'
        browser.textarea(id: 'poi_description').set 'Lorem ipsum...'
        #browser.button(title: 'Odaberite kategoriju').click 
      #  puts browser.select_list(xpath: '/html/body/div[4]/div/div/div[2]/div/div[1]/div/div[1]/div[1]/div/form/div[2]/div[2]/div[1]/div/div[1]/div/div[2]/select').exists?
        #browser.select_list(:css ,'.span3 > select').option(value: '5').click
        #browser.select_list(:xpath, 'id("place-form")/div[2]/div[2]/div[1]/div[1]/div[1]/div[1]/div[3]/select').option(value: '54').click
        browser.text_field(id: 'place_tags').set 'kafa , sarajevo, coffeeplace ,'
        browser.button(id: 'btn_day_sat').click
        browser.text_field(id: 'working_hours_0_0').set '09:00'  
        browser.text_field(id: 'working_hours_0_1').set '22:00'
        browser.text_field(id: 'poi_phone').set '033551551'
    
    end
end


