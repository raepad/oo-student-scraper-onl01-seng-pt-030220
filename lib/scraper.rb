require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_url = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"))
    # binding.pry

    index_url.css(".student-card").map do |profile|
      {name: profile.css("h4.student-name").text,
      location: profile.css("p.student-location").text,
      profile_url: profile.css("a")[0]["href"]
      }
    end
  end


  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    #binding.pry
    student = {}
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute("href").value}
    links.each do |profile|
      if profile.include?("twitter")
        student[:twitter] = profile
      elsif profile.include?("linkedin")
        student[:linkedin] = profile 
      elsif profile.include?("github")
        student[:github] = profile
      else
        student[:blog] = profile
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote").text
    student[:bio] = profile_page.css(".description-holder").css("p").text if profile_page.css(".description-holder").css("p").text

      # twitter: profile.css(".vitals-container").css(".social-icon-container").css("a")[0]["href"],
      # linkedin: profile.css(".vitals-container").css(".social-icon-container").css("a")[1]["href"],
      # github: profile.css(".vitals-container").css(".social-icon-container").css("a")[2]["href"],
      # blog: profile.css(".vitals-container").css(".social-icon-container").css("a")[3]["href"],
      # profile_quote: profile.css(".vitals-container").css(".vitals-text-container").css(".profile-quote").text,
      # bio: profile.css(".details-container").css(".description-holder").css("p").text
    
    student
  end

end

