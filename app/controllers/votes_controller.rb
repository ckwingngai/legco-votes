$arr = [
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160713.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160706.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160622.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160615.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160608.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160601.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160525.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160518.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160511.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160420.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160316.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160217.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160127.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160120.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20160106.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151216.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151202.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151125.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151118.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151111.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151104.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151028.xml',
  'http://www.legco.gov.hk/yr15-16/chinese/counmtg/voting/cm_vote_20151014.xml',
]

require 'net/http'

class VotesController < ApplicationController

  def insert_db(vote)
    unless vote["motion_ch"].nil?
      obj = {
        data: {
          vote_date: vote["vote_date"],
          motion_ch: vote["motion_ch"],
          mover_ch: vote["mover_ch"],
          individual_votes: vote["individual_votes"]
        },
        vote_date: vote["vote_date"]
      }
      vote = VoteHist.create(obj)
      vote.save
    end
  end

  def import

    $arr.each do |item|
      url = URI.parse(item)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      json = Hash.from_xml(res.body).to_json
      data = JSON.parse(json)

      votes = data["legcohk_vote"]["meeting"]
      if votes["vote"].is_a? Array
        puts "array"
        votes["vote"].each do |vote|
          insert_db(vote)
        end
      else
        puts "one"
        insert_db(votes)
      end
    end

  end

  def list
    @result = []
    @data = VoteHist.all
    @data.each do |item|
      puts item.id
      hash = get_item(item.id)
      puts hash
      @result.push(hash)
    end
  end

  def get_item(id)
    data = VoteHist.where(:id => id).first
    hash = eval(data.data)
    hash["id"] = id
    temp_date = hash[:vote_date].split("/")
    hash["date"] = "#{temp_date[2]}-#{temp_date[1]}-#{temp_date[0]}"
    return hash
  end

  def api_get_item
    render :plain => get_item(params[:id].to_i).to_json
  end

end
