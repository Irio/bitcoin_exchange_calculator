#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'open-uri'

require_relative 'bitcoin_exchange_calculator'

complete_history = JSON.parse(open('https://www.mercadobitcoin.com.br/api/trades/').read)
sell_prices      = [
  { date: Time.at(complete_history.first['date']).to_date, price: complete_history.first['price'] },
  { date: Time.at(complete_history.last['date']).to_date,  price: complete_history.last['price'] }
]

complete_history = []
CSV.parse(open('https://coinbase.com/api/v1/prices/historical').read) do |row|
  complete_history << { date: Date.parse(row[0]), price: row[1].to_f }
end
buy_prices = [
  complete_history.find do |price|
    price[:date].eql? sell_prices.first[:date]
  end,
  complete_history.find do |price|
    price[:date].eql? sell_prices.last[:date]
  end
]

sell_prices.each_with_index do |sell_price, index|
  calculator = BitcoinExchangeCalculator.new(
    ARGV.first,
    buy_prices[index][:price],
    sell_price[:price]
  )
  puts "On #{sell_price[:date]}, the final amount would be #{calculator.final_amount}."
end
