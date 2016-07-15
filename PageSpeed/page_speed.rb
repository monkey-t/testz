require 'rubygems'
require 'selenium-webdriver'
#require_relative '../PageSpeed/test'

class Page_speed

  def initialize
    @driver = Selenium::WebDriver.for :firefox, marionette: true
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def open_page
    @driver.get "https://developers.google.com/speed/pagespeed/insights/"
  end

  def input
    @driver.find_element(:xpath, ".//*[@class='url-and-analyze']/input")
  end

  def analyz_btn
    @driver.find_element(:xpath, ".//*[@class='url-and-analyze']/div/div")
  end

  #mobile_tab = @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[1]/div/div[1]/div")

  def get_speed
    speed = @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[2]/div[1]/div[3]/div[2]/h2/span[1]").text
    speed.chomp(" / 100").to_i
  end

  def get_user_exp
    user_experience = @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[2]/div[1]/div[3]/div[3]/h2/span[1]").text
    user_experience.chomp(" / 100").to_i
  end


  def screen_mobile(page_url)
    speed = get_speed
    user_experience = get_user_exp
    if speed < 80
      @driver.save_screenshot("screen/#{page_url}_mobile.png")
      puts "низкая оценка speed - на странице #{page_url} = #{speed}"
    elsif user_experience < 80
      @driver.save_screenshot("screen/#{page_url}_mobile.png")
      puts "низкая оценка user_experience - на странице #{page_url} = #{user_experience}"
    else
      puts "высокая оценка мобильной версии - оценка страницы #{page_url} = #{speed}"
    end
  end

  def sug_summ
    suggestion_summary = @driver.find_element(:xpath, ".//*[@id='page-speed-insights']/div[2]/div/div[2]/div[2]/div[3]/div[2]/h2/span[1]").text
    suggestion_summary.chomp(" / 100").to_i
  end

  def screen_comp(page_url)
    suggestion_summary = sug_summ
    if suggestion_summary < 80
      @driver.save_screenshot("screen/#{page_url}_comp.png")
      puts "низкая оценка комп версии - на странице #{page_url} = #{suggestion_summary}"
    else
      puts "высокая оценка комп версии - оценка страницы #{page_url} = #{suggestion_summary}"
    end
  end

  def speed_test(main_url, page_url)
    input.send_keys main_url + page_url
    analyz_btn.click
    @wait.until { @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[1]/div/div[1]/div").enabled? }
    screen_mobile(page_url)
    comp_tab = @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[1]/div/div[2]/div")
    comp_tab.click
    screen_comp(page_url)
  end

  def quit
    @driver.quit
  end
end
