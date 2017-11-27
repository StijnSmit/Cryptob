//
//  CMCController.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation

// CoinMarketCap:
struct CMC {
   static let baseURL = "https://api.coinmarketcap.com/v1/"
   static let global = "global/"
   static let ticker = "ticker/"
}

class CMCController {
   
   func getGlobalDataMessage() -> String {
      return "Market Cap: $\(globalData.totalMarketCap.formattedWithPoints)  / 24h Vol: $\(globalData.todayVolume.formattedWithPoints)  / BTC Dominance: \(globalData.bitcoinPercentage.formattedWithPoints) %"
   }
   
   func everyday() {
      Timer(timeInterval: day, target: self, selector: #selector(fetchEveryday), userInfo: nil, repeats: true)
   }
   func fetchEveryday() {
      
   }
}
