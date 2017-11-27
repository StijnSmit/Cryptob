//
//  Ticker.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import CoreFoundation
import Dispatch
import Foundation

struct CMCTicker {
   var id: String
   var name: String
   var symbol: String
   var rank: String
   var priceUSD: String
   var priceBTC: String
   var dayVolumeUSD: String
   var marketCapUSD: String
   var availableSupply: String
   var totalSupply: String
   var percentChangeHour: String
   var percentChangeDay: String
   var percentChangeWeek: String
   var lastUpdated: String
   
   enum CodingKeys: String {
      case id = "id"
      case name = "name"
      case symbol = "symbol"
      case rank = "rank"
      case priceUSD = "price_usd"
      case priceBTC = "price_btc"
      case dayVolumeUSD = "24h_volume_usd"
      case marketCapUSD = "market_cap_usd"
      case availableSupply = "available_supply"
      case totalSupply = "total_supply"
      case percentChangeHour = "percent_change_1h"
      case percentChangeDay = "percent_change_24h"
      case percentChangeWeek = "percent_change_7d"
      case lastUpdated = "last_updated"
   }
   
   init?(json: [String: Any]) {
      guard let id = json[CodingKeys.id.rawValue] as? String,
            let name = json[CodingKeys.name.rawValue] as? String,
            let symbol = json[CodingKeys.symbol.rawValue] as? String,
            let rank = json[CodingKeys.rank.rawValue] as? String,
            let priceUSD = json[CodingKeys.priceUSD.rawValue] as? String,
            let priceBTC = json[CodingKeys.priceBTC.rawValue] as? String,
            let dayVolumeUSD = json[CodingKeys.dayVolumeUSD.rawValue] as? String,
            let marketCapUSD = json[CodingKeys.marketCapUSD.rawValue] as? String,
            let availableSupply = json[CodingKeys.availableSupply.rawValue] as? String,
            let totalSupply = json[CodingKeys.totalSupply.rawValue] as? String,
            let percentChangeHour = json[CodingKeys.percentChangeHour.rawValue] as? String,
            let percentChangeDay = json[CodingKeys.percentChangeDay.rawValue] as? String,
            let percentChangeWeek = json[CodingKeys.percentChangeWeek.rawValue] as? String,
            let lastUpdated = json[CodingKeys.lastUpdated.rawValue] as? String else {
            return nil
      }
      self.init(id: id, name: name, symbol: symbol, rank: rank, priceUSD: priceUSD, priceBTC: priceBTC, dayVolumeUSD: dayVolumeUSD, marketCapUSD: marketCapUSD, availableSupply: availableSupply, totalSupply: totalSupply, percentChangeHour: percentChangeHour, percentChangeDay: percentChangeDay, percentChangeWeek: percentChangeWeek, lastUpdated: lastUpdated)
   }
   
   init(id: String, name: String, symbol: String, rank: String, priceUSD: String, priceBTC: String, dayVolumeUSD: String,
        marketCapUSD: String, availableSupply: String, totalSupply: String, percentChangeHour: String, percentChangeDay: String,
        percentChangeWeek: String, lastUpdated: String) {
      self.id = id
      self.name = name
      self.symbol = symbol
      self.rank = rank
      self.priceUSD = priceUSD
      self.priceBTC = priceBTC
      self.dayVolumeUSD = dayVolumeUSD
      self.marketCapUSD = marketCapUSD
      self.availableSupply = availableSupply
      self.totalSupply = totalSupply
      self.percentChangeHour = percentChangeHour
      self.percentChangeDay = percentChangeDay
      self.percentChangeWeek = percentChangeWeek
      self.lastUpdated = lastUpdated
   }
}
