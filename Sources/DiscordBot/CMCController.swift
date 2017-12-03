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
    var network: Network!

    init(network: Network) {
        self.network = network
    }

   func globalDataMessage(completion: @escaping (String?) -> ()) {
        self.getLatestGlobalData() { globalData in
           guard let globalData = globalData else { completion(nil); return }
           completion(globalData.marketMessage())
        }
   }

   func tickerMessage(input: [String], completion: @escaping (String?) -> ()) {
       if input.count < 1 { print("InputCount not good"); completion(nil); return }
       self.getTicker(name: (input.first)!) { ticker in 
           guard let ticker = ticker else { print("Ticker can't be ticker"); completion(nil); return }
           if input.count > 1 && input[1] == "detail" {
               completion(ticker.detailMessage())
           } else {
               completion(ticker.message())
           }
       }
   }

   func getLatestGlobalData(completion: @escaping (CMCGlobalData?) -> ()) {
        DispatchQueue.global().async {
            self.network.globalData() { (json) in
                guard let json = json, let globalData = CMCGlobalData(json: json) else { completion(nil); return }
                DispatchQueue.main.async {
                    completion(globalData)
                }
            }
        }
   }

   func getTicker(name: String, completion: @escaping (CMCTicker?) -> ()) {
        DispatchQueue.global().async {
            self.network.ticker(name: name) { (json) in
                guard let json = json, let ticker = CMCTicker(json: json) else { print("Ticker can't be ticker first"); completion(nil); return }
                DispatchQueue.main.async {
                    completion(ticker)
                }
           }
        }
   }
/*
   func everyday() {
      Timer.scheduledTimer(timeInterval: 60, target: self,
          selector: #selector(fetchEveryday), userInfo: nil, repeats: true)
   }

   @objc func fetchEveryday() {
       print("EVERYDAY")
   }
   */
}
