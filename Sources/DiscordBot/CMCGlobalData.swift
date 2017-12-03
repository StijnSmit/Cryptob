import CoreFoundation
import Dispatch
import Foundation

struct CMCGlobalData {
   var totalMarketCap: Int
   var todayVolume: Int
   var bitcoinPercentage: Double
   var activeCurrencies: Int
   var activeAssets: Int
   var activeMarkets: Int
   var lastUpdated: Int
   
   enum CodingKeys: String {
      case totalMarketCap = "total_market_cap_usd"
      case todayVolume = "total_24h_volume_usd"
      case bitcoinPercentage = "bitcoin_percentage_of_market_cap"
      case activeCurrencies = "active_currencies"
      case activeAssets = "active_assets"
      case activeMarkets = "active_markets"
      case lastUpdated = "last_updated"
   }
   
   static func endpoint() -> String {
      return CMC.baseURL + CMC.global
   }
   
   init?(json: [String: Any]) {
      guard let totalMarketCap = json[CodingKeys.totalMarketCap.rawValue] as? Int,
         let todayVolume = json[CodingKeys.todayVolume.rawValue] as? Int,
         let bitcoinPercentage = json[CodingKeys.bitcoinPercentage.rawValue] as? Double,
         let activeCurrencies = json[CodingKeys.activeCurrencies.rawValue] as? Int,
         let activeAssets = json[CodingKeys.activeAssets.rawValue] as? Int,
         let activeMarkets = json[CodingKeys.activeMarkets.rawValue] as? Int,
         let lastUpdated = json[CodingKeys.lastUpdated.rawValue] as? Int else {
            return nil
      }
      self.init(totalMarketCap: totalMarketCap, todayVolume: todayVolume,
                bitcoinPercentage: bitcoinPercentage, activeCurrencies: activeCurrencies,
                activeAssets: activeAssets, activeMarkets: activeMarkets, lastUpdated: lastUpdated)
   }
   
   init(totalMarketCap: Int, todayVolume: Int, bitcoinPercentage: Double, activeCurrencies: Int, activeAssets: Int, activeMarkets: Int, lastUpdated: Int) {
      self.totalMarketCap = totalMarketCap
      self.todayVolume = todayVolume
      self.bitcoinPercentage = bitcoinPercentage
      self.activeCurrencies = activeCurrencies
      self.activeAssets = activeAssets
      self.activeMarkets = activeMarkets
      self.lastUpdated = lastUpdated
   }

   func marketMessage() -> String {
      return "Market Cap: $\(self.totalMarketCap.formattedWithPoints)"
            + "  / 24h Vol: $\(self.todayVolume.formattedWithPoints)"
            + "  / BTC Dominance: \(self.bitcoinPercentage) %"
   }
}
