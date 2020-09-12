module Cryptoexchange::Exchanges
  module Covex
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Covex::Market::API_URL}/api/v1/ticker"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          output.map do |pair|
            base, target = pair.first
            Cryptoexchange::Models::MarketPair.new(
              base:   base,
              target: target,
              market: Covex::Market::NAME
            )
          end
        end
      end
    end
  end
end