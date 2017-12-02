//
//  CMCController.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation

enum BackendError: Error {
   case urlError(reason: String)
   case objectSerialization(reason: String)
}

// CoinMarketCap:
struct CMC {
   static let baseURL = "https://api.coinmarketcap.com/v1"
   static let global = "global"
   static let ticker = "ticker"
}

class CMCController {
    var globalData: CMCGlobalData? = nil
    var tickers: [CMCTicker]!

    init() {
        self.fetchGlobalData()
        everyday()
    }

   func globalDataMessage() -> String {
       guard let globalData = globalData else { return "" }
      return "Market Cap: $\(globalData.totalMarketCap.formattedWithPoints)"
            + "  / 24h Vol: $\(globalData.todayVolume.formattedWithPoints)"
            + "  / BTC Dominance: \(globalData.bitcoinPercentage) %"
   }

   func tickerMessage(ticker: [String]) -> String {
    return "Work In Progress :computer:"    
   }

   func fetchGlobalData() {
        DispatchQueue.global().async {
            CMCGlobalData.globalData() { (globalData, error) in
                guard let globalData = globalData, error == nil else {
                    return
                }
                self.globalData = globalData
            }
        }
   }
   
   func everyday() {
      Timer.scheduledTimer(timeInterval: 60, target: self,
          selector: #selector(fetchEveryday), userInfo: nil, repeats: true)
   }

   @objc func fetchEveryday() {
        self.fetchGlobalData()
   }
}
