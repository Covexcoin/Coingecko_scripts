module Cryptoexchange::Exchanges
  module Covex
    module Services
      class OrderBook < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          params = {}
          params['Pair'] = "#{market_pair.base}#{market_pair.target}"
          output = fetch_using_post(ticker_url, params)
          adapt(output, market_pair)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Covex::Market::API_URL}Class/API/OrderBook.php"
        end

        def adapt(output, market_pair)
          #puts adapt_orders
          #output.collect do |trade|
          order_book = Cryptoexchange::Models::OrderBook.new
          order_book.base      = market_pair.base
          order_book.target    = market_pair.target
          order_book.market    = Covex::Market::NAME
          order_book.asks      = adapt_orders(output['Info']['Sell'])
          order_book.bids      = adapt_orders(output['Info']['Buy'])
          order_book.payload   = output
          order_book
        end

	def adapt_orders(orders)
          orders.collect do |order_entry|
          	Cryptoexchange::Models::Order.new(price: order_entry['Price'],
                          amount: order_entry['Volume'])
        end
        end
      end
    end
  end
end
