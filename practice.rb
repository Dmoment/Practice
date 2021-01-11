require 'net/http'
require 'uri'
require 'json'

class UrlConfig
  def initialize(url)
    @url = url
  end
  
  def base_url
    return URI.parse(@url)
  end
end

class ParsedTypeResponse

  def initialize(url)
    @url = url
  end

  def fetched_type_attribute
    response = Net::HTTP.get_response config.base_url
    puts response.body.class
    parsed_response = JSON.parse(response.body)
    type_attribute = []
    parsed_response.each do |data|
      type_attribute.push(data["type"])
    end
    return type_attribute
  end

  def config
    @config = UrlConfig.new(@url)
  end
end



class TenderLoveScore

  def initialize(url , event_type)
    @url = url
    @event_type = event_type
  end

  def score
   types = commit_type.fetched_type_attribute
   sum = 0
   types.each do |type|
    if @event_type.key?(type)
      sum += @event_type[type]
    else
      sum += 1  
    end
   end
   return "TenderLove's github score is #{sum}"
  end

  def commit_type
    @commit_type ||= ParsedTypeResponse.new(@url)
  end
end

event_type = {"IssuesEvent" => 7,
              "IssueCommentEvent" => 6,
              "PushEvent" => 5,
              "PullRequestReviewCommentEvent" => 4,
              "WatchEvent" => 3,
              "CreateEvent" => 2
              }
tender_url = "https://api.github.com/users/tenderlove/events/public"
tender_love_score = TenderLoveScore.new(tender_url , event_type)
puts "hello World"
puts tender_love_score.score
