//
//  CMCController.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation
import Dispatch

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
   var symbolStorage: CMCSymbolStorage!
    var network: Network!

    init(network: Network) {
      self.network = network
      self.symbolStorage = CMCSymbolStorage(network: network)
      self.symbolStorage.fetchLatestSymbols()
    }

   func globalDataMessage(completion: @escaping (String?) -> ()) {
        self.getLatestGlobalData() { globalData in
           guard let globalData = globalData else { completion(nil); return }
           completion(globalData.marketMessage())
        }
   }
   
   private func tickerMessage(type: String, input: [String], completion: @escaping (String?) -> ()) {
      if input.count < 1 { print("InputCount not good"); completion(nil); return }
      self.getTicker(name: (input.first)!) { ticker in
         guard let ticker = ticker else { print("Ticker can't be ticker"); completion(nil); return }
         if type == "status" {
            completion(ticker.statusMessage())
         } else if type == "detail" {
            completion(ticker.detailMessage())
         }
      }
   }

   func statusMessage(input: [String], completion: @escaping (String?) -> ()) {
      self.tickerMessage(type: "status", input: input, completion: completion)
   }
   
   func detailMessage(input: [String], completion: @escaping (String?) -> ()) {
      self.tickerMessage(type: "detail", input: input, completion: completion)
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
         let symbol = self.symbolStorage.getSymbol(for: name)
            self.network.ticker(symbol: symbol) { (json) in
                guard let json = json, let ticker = CMCTicker(json: json) else { print("Ticker can't be ticker first"); completion(nil); return }
                DispatchQueue.main.async {
                    completion(ticker)
                }
           }
        }
   }

   func everyday() {
//      Timer.scheduledTimer(timeInterval: day, target: self,
//          selector: #selector(fetchEveryday), userInfo: nil, repeats: true)
   }

   @objc func fetchEveryday() {
      self.symbolStorage.fetchLatestSymbols()
   }
}
