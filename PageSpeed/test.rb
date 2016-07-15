require 'rubygems'
require 'selenium-webdriver'
require_relative '../PageSpeed/page_speed'




main_url = "http://wm-help.net/lib/b/book/827961078/"
page_url = [test_page, qwe, ewq]

def run_test(main_url, page_url)
  test = Page_speed.new
  test.open_page
  test.speed_test(main_url, page_url)
  test.quit
end

page_url.each { |x| run_test(main_url, page_url + x) }



