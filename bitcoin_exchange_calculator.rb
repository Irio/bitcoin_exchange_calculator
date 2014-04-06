class BitcoinExchangeCalculator
  attr_accessor :purchase_amount, :buy_price, :sell_price

  def initialize(purchase_amount, buy_price, sell_price)
    @purchase_amount = purchase_amount.to_f
    @buy_price       = buy_price.to_f
    @sell_price      = sell_price.to_f
  end

  def bought_bitcoins
    # Buying fees
    amount = (@purchase_amount - 0.15) / 1.01

    amount / @buy_price
  end

  def selled_amount
    # Selling fees
    selled_bitcoins = bought_bitcoins / 1.007

    selled_bitcoins * @sell_price
  end

  def final_amount
    # Takeout fees
    0.9801 * selled_amount - 2.9
  end
end
