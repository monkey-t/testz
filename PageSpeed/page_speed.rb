require 'rubygems'
require 'selenium-webdriver'
#require_relative '../PageSpeed/test'

class Page_speed

  attr_reader :page_url

  def initialize
    @driver = Selenium::WebDriver.for :firefox, marionette: true

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

  def screen
    primari_score = @driver.find_element(:xpath, ".//*[@class='result-group-title']/span[1]").text
    score = primari_score.chomp(" / 100").to_i
    if score < 80
      @driver.save_screenshot("screen/#{page_url}.png")
    else
      puts score
    end
  end

  def speed_test(main_url, page_url)
    input.send_keys main_url + page_url
    analyz_btn.click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { @driver.find_element(:xpath, ".//*[@class='result-group-title']/span[1]").enabled? }
    screen
    comp_tab = @driver.find_element(:xpath, ".//*[@class='pagespeed-results']/div/div[1]/div/div[2]/div")
    comp_tab.click
    screen
  end
end
