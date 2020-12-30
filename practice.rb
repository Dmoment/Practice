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
    parsed_response = JSON.parse(response.body)
    type_attribute = []
    parsed_response.each do |data|
      type_attribute.push(data["type"])
    end
    return type_attribute
  end

  def config
    @config ||= UrlConfig.new(@url)
  end
end


class TenderLoveScore

  def initialize(url)
    @url = url
  end

  def score
   types = commit_type.fetched_type_attribute
   sum = 0
   types.each do |type|
    case type
    when "IssuesEvent"
      sum += 7
    when "IssueCommentEvent"
      sum += 6
    when "PushEvent"
      sum += 5
    when "PullRequestReviewCommentEvent"
      sum += 4
    when "WatchEvent"
      sum += 3
    when "CreateEvent"
      sum += 2
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


tender_url = "https://api.github.com/users/tenderlove/events/public"
tende_love_score = TenderLoveScore.new(tender_url)
puts tender_love_score.score
