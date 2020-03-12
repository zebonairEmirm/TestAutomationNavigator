require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/rspec'


Capybara.default_driver = :selenium_chrome  #Defines a driver/browser
Capybara.ignore_hidden_elements = false     #We need this to uncover hidden items within the website


RSpec.describe 'Navigator Smoke Test', type: :feature do


  #It basically runs the website again for each case
  before(:each) do
    visit 'https://www.navigator.ba/#/categories'
  end

  it 'Searches for a place' do
    fill_in "Traži ulicu ili objekat", with: 'Sunnyland' 
    find('.iconav-search').click
    link = page.find(:css, 'a[href="#/p/sunnyland"]') #finding and item by the link
    link.click
    expect(page).to have_text 'Miljevići bb' #expecting to see the address
    expect(page).to have_css '.leaflet-popup-content' #expecting the description popup on the map
    sleep(2)
  end 

  it 'Creates a Place'  do 
    find('#ember566', visible: false).click

      #Place Description
      fill_in 'poi_name', with: 'Lorem Ipsum Buregdžinica'
      fill_in 'poi_city_name', with: 'Sarajevo'
      fill_in 'poi_zip_code', with: '71 000'
      fill_in 'poi_place_id', with: 'Trg Djece Sarajeva'
      fill_in 'poi_house_number', with: '22'
      fill_in 'poi_description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '

      #Place Category
      find_button('Odaberite kategoriju').click 
      find('.span3 option[value="4"]').select_option
      find('.span3 option[value="21"]').select_option
      find('.span4 option[value="18"]').select_option
      
      #Working hours 
      find('#btn_day_sat')

      #Following function is capybara interaction with javascript
      #The saturday button by default is not ineractable when we automate the process, so I had to use this to make it clickable 
      execute_script("arguments[0].click();", page.find("#btn_day_sat", visible: false)) 
      fill_in 'working_hours_0_0', with: '09:00'
      fill_in 'working_hours_0_1', with: '18:00'

      #Place Contact(s)
      fill_in 'poi_phone', with: '033556668'
      fill_in 'poi_mobile_phone', with: '061555000'

      #Place Web locations/contacts
      fill_in 'poi_web', with: 'http://wikepedia.com'
      fill_in 'poi_facebook_url', with: 'https://www.facebook.com/profile.php?id=100047500742361'
      fill_in 'poi_email', with: 'cashmoney@testmail.com'

      #Wireless
      find('#poi_has_wifi').set(true)
      
      #Uploading image
      find('#fileToUpload', visible: false).set('/Users/admin/Desktop/homer.jpg')

      #Comment
      find('#poi_comment').set 'Nice'
        
      find_button("Kreiraj", visible: false)
      
      #Using the same function for the 'Create' button since its hidden and not interactable by default
      execute_script("arguments[0].click();", page.find("button.btn-success", visible: false)) 
  
      expect(page).to have_text "Lorem Ipsum Buregdžinica" #Expecting name of the place
      expect(page).to have_css '.leaflet-popup-content'      #Expecting description popup on the map
      sleep(2) 
  end

  it 'Suggests a feature' do 
    find('#ember581').click 
      fill_in "Ime i prezime", with: 'Test User'
      fill_in "Email", with: 'emir.muratcaus97@gmail.com'
      fill_in "Komentar", with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      find_button('Pošalji').click
      expect(page).to have_content "Hvala na poruci! Potrudit ćemo se da što prije reagujemo." #expecting succcess message
      sleep(2)
  end
end    