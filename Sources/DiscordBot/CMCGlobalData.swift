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
   
   static func globalData(completion: @escaping (CMCGlobalData?, Error?) -> ()) {
      guard let url = URL(string: CMCGlobalData.endpoint()) else { print("Can't Make URL"); return }
      let urlRequest = URLRequest(url: url)
      print("URL: \(url)")
      print("URLRequest: \(urlRequest)")
      let session = URLSession.shared
      let task = session.dataTask(with: urlRequest, completionHandler: {
         (data, response, error) in
         print("Returned from request")
         guard error == nil else {
            print("Error")
            completion(nil, error)
            return
         }
         guard let responseData = data else { print("Error: did not receivedata")
            let error = BackendError.objectSerialization(reason: "No data in response")
            completion(nil, error)
            return
         }
         do {
            print("DO")
            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
               print("JSON")
               print(json)
               let globalData = CMCGlobalData(json: json)
               print(globalData)
               completion(globalData, nil)
            } else {
               print("Couldn't create GlobalData")
               let error = BackendError.objectSerialization(reason: "Couldn't create a GlobalData object from the JSON")
               completion(nil, error)
            }
         } catch {
            completion(nil, error)
            return
         }
         
      })
      task.resume()
   }
}
