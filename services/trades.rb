module Cryptoexchange::Exchanges
  module Covex
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output['Info']['LTCBTC'], market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Covex::Market::API_URL}/api/v1/trades/#{market_pair.base}#{market_pair.target}"
        end

        def adapt(trades, market_pair)
          trades.collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade['tradeId'].to_i
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.price     = trade['price'].to_f
            tr.amount    = trade['volume'].to_f
            tr.timestamp = trade['time'].to_i / 1000
            tr.payload   = trade
            tr.market    = Covex::Market::NAME
            tr
          end
        end
      end
    end
  end
end

