require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'rspec'

Capybara.default_driver = :selenium_chrome
Capybara.ignore_hidden_elements = false

RSpec.describe 'Regression test', type: :feature do

  before(:each) do
    page.driver.browser.manage.window.maximize #fullscreen mode
    visit 'https://www.navigator.ba/#/categories'
  end

  it 'Zooms in and out on the map'  do
    find('.leaflet-control-zoom-in').click              
    expect(page).to have_text('+')        
    sleep(2)
    find('.leaflet-control-zoom-out').click
    expect(page).to have_text('-')
    sleep(2)
  end

  it 'Clicks on one of the Category cards, clicks place, goes back to home page' do 
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click
    find("a[href='#/p/narodno-pozoriste?list=sarajevska-pozorista']").click
    expect(page).to have_current_path('https://www.navigator.ba/#/p/narodno-pozoriste?list=sarajevska-pozorista')
    sleep(1)
    find('.logo').click
    expect(page).to have_current_path('https://www.navigator.ba/#/categories')
    sleep(1)
  end


   it 'Show image and place description' do 
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    expect(page).to have_current_path('https://www.navigator.ba/#/list/sarajevska-pozorista')
    find("a[href='#/p/narodno-pozoriste?list=sarajevska-pozorista']").click
    find('.ember-view.profile-image-container').click
    sleep(2)
    find('#cboxNext').click
    sleep(2)
    find('#cboxClose').click
    sleep(1)
    find('.show-more-content').click
    sleep(2)  
    #needs to scroll into view
    #needs expectation
   end

=begin
  it 'Leave a rating' do
    #inconsistent, have to change place or increment rating on every new test
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    find("a[href='#/p/magacin-kabare--2?list=sarajevska-pozorista']").click
    expect(page).to have_content('13 ocjena') 
    find('.empty', visible:false).hover 
    sleep(2)
    execute_script("arguments[0].click();", find('.empty span[data-value="1"]', visible: false))
    sleep(3)
    expect(page).to have_content('14 ocjena') 
  end
=end
  it 'Suggest changes' do
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    find("a[href='#/p/sartr?list=sarajevska-pozorista']").click
    execute_script("arguments[0].click();", find("button.btn-success.btn-suggest-edit", visible: false))
    find('#poi_place_id').native.clear #deleting the existing address from input
    #sleep(1)
    fill_in "poi_place_id", with: 'Gandijeva'
    sleep(2) #important sleep here
    find_button('Odaberite kategoriju').native.send_keys( :tab,:tab, :tab, :tab, :tab, :tab,:tab, :tab, :tab, 
      :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,
      :tab,:tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, 
      :tab,:tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, 
      :tab, :tab, :tab, :tab )  #tabbing through the form to find button, because scroll function didn't work
    execute_script("arguments[0].click();", find('button.btn-success'))
    expect(page).to have_content('Zahvaljujemo Vam na predloženim izmjenama. Vaše izmjene će biti vidljive nakon revizije.')
    find_button('OK').click
    #sleep(2)
  end

  it 'Suggest changes with invalid input and exits form' do 
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    find("a[href='#/p/sartr?list=sarajevska-pozorista']").click
    execute_script("arguments[0].click();", find("button.btn-success.btn-suggest-edit", visible: false))
    fill_in 'poi_mobile_phone', with: 'textinnumberfield' #the invalid input part, should not accept letters in number fields
    sleep(2) #important sleeps
    find('#poi_fax').native.send_keys( :tab,:tab, :tab, :tab, :tab, :tab,:tab, :tab, :tab, 
      :tab,:tab, :tab, :tab, :tab,:tab,)
    execute_script("arguments[0].click();", find('button.btn-success'))
    expect(page).to have_content('Forma sadrži nevalidne podatke. Molimo ispravite i pokušajte ponovo')
    sleep(2)   
  end 

  it 'Claim Place' do
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    find("a[href='#/p/sartr?list=sarajevska-pozorista']").click
    execute_script("arguments[0].click();", page.find("button.btn-claim", visible: false))
    fill_in "Vaše ime", with: 'User Claims'
    fill_in "Vaš email", with: 'claim@something.com'
    fill_in "Vaš telefon", with: '+38761970827'
    click_button 'Pošalji'
    expect(page).to have_content('Poruka uspješno poslana. Navigator tim će Vas kontaktirati u roku od 48 sati')
  end

  it 'Claim Place without filling out required fields, negative input, exit Claim Place' do

    #Expecting to see highlighted fields when there is no input in forms
    find(:xpath, "//a[@href='#/list/sarajevska-pozorista']").click 
    find("a[href='#/p/sartr?list=sarajevska-pozorista']").click
    execute_script("arguments[0].click();", page.find("button.btn-claim", visible: false))
    click_button('Pošalji')
    sleep(2)
    bordClr = find('.emailcheck').native.css_value('border-color')
    bordClr2 = find('.phonecheck').native.css_value('border-color')
    expect(bordClr).to eq('rgb(185, 74, 72)')
    expect(bordClr2).to eq('rgb(185, 74, 72)')

    #Expecting email and phone to be highlighted, failing in sending message 
    fill_in 'Vaše ime', with: 'Emir'
    fill_in 'Vaš email', with: 'cashmoneynomail'
    fill_in 'Vaš telefon', with: 'dontputtextinnumberfield'
    click_button('Pošalji')
    sleep(2)
    expect(bordClr).to eq('rgb(185, 74, 72)')
    expect(bordClr2).to eq('rgb(185, 74, 72)')

    #Quits the form, gets back to the place description
    click_button('Odustani')
    sleep(2)
    expect(page).to have_current_path('https://www.navigator.ba/#/p/sartr?list=sarajevska-pozorista')
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


  it 'Searches for a place with invalid input' do 
    fill_in "Traži ulicu ili objekat", with: '#000=?' 
    find('.iconav-search').click
    expect(page).to have_text 'Žao nam je. Nismo uspjeli pronaći niti jedan rezultat za traženu pretragu.'
    expect(page).to have_button 'Dodaj ovaj objekat'
  end

  it 'Creates a place ' do 
    find('#ember566').click

    #Drags Marker
    source = page.find('.leaflet-marker-draggable')
    sleep(3)
    puts 'Marker coordinates before moving' + " " + source.native.css_value('transform')
    execute_script("arguments[0].setAttribute('style', 'transform: translate3d(732px, 325px, 90px); z-index: 325;');", source)
    puts 'Marker coordinates after being moved' + " " + source.native.css_value('transform')
    sleep(3)

    #Place description
    fill_in 'Naziv', with: 'XYZ Agencija'
    fill_in 'Grad', with: 'Sarajevo'
    fill_in 'Poštanski broj', with: '71000'
    fill_in 'Ulica', with: 'Franca Lehara'
    fill_in 'Kućni broj', with: '18'
    fill_in 'Alternativna adresa', with: 'Ljubljanska 8'
    fill_in 'Opis', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    
    #Category, tags
    find_button('Odaberite kategoriju').click
    #Coffee -> Coffee Place -> Espresso 
    find('.span3 option[value="5"]').select_option
    find('.span3 option[value="52"]').select_option
    find('.span4 option[value = "51"]').select_option
 
    #Working Hours
    find('#btn_day_sat')
 
    execute_script("arguments[0].click();", page.find("#btn_day_sat", visible: false)) 
    fill_in 'working_hours_0_0', with: '09:00'
    fill_in 'working_hours_0_1', with: '18:00'

    #Place Contact(s)
    fill_in 'poi_phone', with: '033556668'
    fill_in 'poi_mobile_phone', with: '061555000'

    #Place Web locations/contacts
    fill_in 'poi_web', with: 'http://wikepedia.com'
    fill_in 'poi_email', with: 'cashmoney@testmail.com'
    fill_in 'poi_facebook_url', with: 'https://www.facebook.com/profile.php?id=100047500742361'
    fill_in 'poi_twitter_url', with: 'https://twitter.com/'
    fill_in 'poi_instagram_url', with: 'https.//instagram.com'
    fill_in 'poi_wikipedia_url', with: 'http://wikepedia.com'
    fill_in 'poi_tripadvisor_url', with: 'https://www.tripadvisor.com/'
    fill_in 'poi_youtube_url', with: 'https://youtube.com'
    fill_in 'poi_instagram_hashtag', with: 'xyz'

    #Wireless
    find('#poi_has_wifi').set(true)
    
    #Uploading image
    find('#fileToUpload', visible: false).set('/Users/admin/Desktop/homer.jpg')

    #Accept Credit Cards
    execute_script("arguments[0].click();", page.find("#poi_accepts_credit_cards", visible: false))
    execute_script("arguments[0].click();", page.find("#chk_credit_card_3", visible: false)) 

    #Comment
    find('#poi_comment').set 'Nice Job'
    
    sleep(2)
    find_button("Kreiraj", visible: false)
    
    #Using the same function for the 'Create' button since its hidden and not interactable by default
    #execute_script("arguments[0].click();", page.find("button.btn-success", visible: false)) 

    sleep(6)
  end

  it 'Creates place without filling out the required fields then exists form' do 
    find('#ember566').click
    fill_in 'Grad', with: 'Sarajevo'
    fill_in 'Poštanski broj', with: '71000'
    fill_in 'Ulica', with: 'Franca Lehara'
    fill_in 'Kućni broj', with: '18'
    find('#poi_comment').set 'Nice Job'
    execute_script("arguments[0].click();", page.find("button.btn-success", visible: false)) 
    expect(page).to have_text "Forma sadrži nevalidne podatke. Molimo ispravite i pokušajte ponovo"
    sleep(2)
    execute_script("arguments[0].click();", page.find("button.btn.cancel", visible: false))
    expect(page).to have_current_path('https://www.navigator.ba/#/categories')
    sleep(1)
  end

  it 'Changes the language to English, reports a problem' do
    find('.en').click
    find('#ember581').click
    fill_in 'name_surname', with: 'Reporting User'
    fill_in 'Email', with: 'wfh@mail.com'
    fill_in 'comment', with: 'Some parts of the website were not translated'
    find(:xpath, '//*[@id="feedback"]/div[4]/label[2]/input').set(true)
    sleep(2)
    find('.btn.green-button').click
    expect(page).to have_content "Thank you for your message! We will do our best to make this happen."
    sleep(2)
  end

  it 'Sends message without filling in the required field, puts invalid mail, exits form' do
    find('#ember581').click
    fill_in 'name_surname', with: 'Reporting User'
    fill_in 'Email', with: 'wfh@mail.com'
    find('.btn.green-button').click
    sleep(2)
    bordClr = find('.required').native.css_value('border-color')
    expect(bordClr).to eq('rgb(185, 74, 72)')

    fill_in 'Email', with: '12345'
    fill_in 'comment', with: 'Nice'
    find('.btn.green-button').click
    sleep(2)
    bordClr2 = find('.emailcheck').native.css_value('border-color')
    expect(bordClr2).to eq('rgb(185, 74, 72)')

    find('.btn.grey-button').click
    expect(page).to have_current_path('https://www.navigator.ba/#/categories')
    sleep(2)
  end

  #Footer Links
  it 'Google Play Link' do
    gglPlaytab = window_opened_by{
       find('.ember-view.apps-widget').click
       }
    within_window gglPlaytab do
        expect(page).to have_current_path('https://play.google.com/store/apps/details?id=com.atlantbh.navigator')
        sleep(1)
    end
  end
  it 'O Navigatoru Link' do
    click_link('O Navigatoru')
    expect(page).to have_current_path('https://www.navigator.ba/#/about')
    sleep(1)
  end

  it 'Leaflet Link' do
    click_link('Leaflet')
    expect(page).to have_current_path('https://leafletjs.com/')
    sleep(1)
  end

  it 'Atlantbh Link' do
    atlTab = window_opened_by{ 
      click_link('© Atlantbh 2018 OSM contributors')
    }
    within_window atlTab do
        expect(page).to have_current_path('https://www.atlantbh.com/')
        sleep(1)
    end
  end

  it 'Changes to English language, navigates content on About' do
    find('.en').click
    click_link('About')
    expect(page).to have_current_path('https://www.navigator.ba/#/about')
    find('.carousel-control.right').click
    sleep(2)
    find('.carousel-control.right').click
    sleep(2)
    find('.carousel-control.right').click
    sleep(2)
    find('.carousel-control.right').click
  end
end

