#!/usr/bin/env ruby
require 'net/http'
require 'csv'

#config shizzle
symbols = [
  'AAPL' #just 1
]

points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '1m', :first_in => 0 do |job|
  
  s = symbols.join(',').upcase
  http = Net::HTTP.new("download.finance.yahoo.com")
  response = http.request(Net::HTTP::Get.new("/d/quotes.csv?fb=nsac1&s=#{s}"))
  
  if response.code != "200"
    puts "yahoo stock quote communication error (status-code: #{response.code})\n#{response.body}"
  else
    # read data from csv
    data = CSV.parse(response.body)

    stocklist = Array.new

    # iterate over different stock symbols and create
    # the list and single values to be pushed to the frontend
    data.each do |line|
      name = line[0]
      current = line[2].to_f

   points.shift
  last_x += 1
  points << { x: last_x, y: current }


        send_event('graph', points: points)
  

 end
end
  end
