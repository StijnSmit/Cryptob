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
   var rank: Int
   var priceUSD: Double
   var priceBTC: Double
   var dayVolumeUSD: Int
   var marketCapUSD: Int
   var availableSupply: Int
   var totalSupply: Int
   var percentChangeHour: Double
   var percentChangeDay: Double
   var percentChangeWeek: Double
   var lastUpdated: Int
   
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
       print(json)
      guard let id = json[CodingKeys.id.rawValue] as? String,
            let name = json[CodingKeys.name.rawValue] as? String,
            let symbol = json[CodingKeys.symbol.rawValue] as? String,
            let sRank = json[CodingKeys.rank.rawValue] as? String,
            let rank = Int(sRank),
            let sPriceUSD = json[CodingKeys.priceUSD.rawValue] as? String,
            let priceUSD = Double(sPriceUSD),
            let sPriceBTC = json[CodingKeys.priceBTC.rawValue] as? String,
            let priceBTC = Double(sPriceBTC),
            let sDayVolumeUSD = json[CodingKeys.dayVolumeUSD.rawValue] as? String,
            let dayVolumeUSD = Double(sDayVolumeUSD),
            let sMarketCapUSD = json[CodingKeys.marketCapUSD.rawValue] as? String,
            let marketCapUSD = Double(sMarketCapUSD),
            let sAvailableSupply = json[CodingKeys.availableSupply.rawValue] as? String,
            let availableSupply = Double(sAvailableSupply),
            let sTotalSupply = json[CodingKeys.totalSupply.rawValue] as? String,
            let totalSupply = Double(sTotalSupply),
            let sPercentChangeHour = json[CodingKeys.percentChangeHour.rawValue] as? String,
            let percentChangeHour = Double(sPercentChangeHour),
            let sPercentChangeDay = json[CodingKeys.percentChangeDay.rawValue] as? String,
            let percentChangeDay = Double(sPercentChangeDay),
            let sPercentChangeWeek = json[CodingKeys.percentChangeWeek.rawValue] as? String,
            let percentChangeWeek = Double(sPercentChangeWeek),
            let sLastUpdated = json[CodingKeys.lastUpdated.rawValue] as? String,
            let lastUpdated = Int(sLastUpdated) else {
            return nil
      }
        print(percentChangeHour)
        print(percentChangeDay)
        print(percentChangeWeek)
      self.init(id: id, name: name, symbol: symbol, rank: rank, priceUSD: priceUSD, priceBTC: priceBTC, dayVolumeUSD: Int(dayVolumeUSD), marketCapUSD: Int(marketCapUSD), availableSupply: Int(availableSupply), totalSupply: Int(totalSupply), percentChangeHour: percentChangeHour, percentChangeDay: percentChangeDay, percentChangeWeek: percentChangeWeek, lastUpdated: lastUpdated)
   }
   
   init(id: String, name: String, symbol: String, rank: Int, priceUSD: Double, priceBTC: Double, dayVolumeUSD: Int,
        marketCapUSD: Int, availableSupply: Int, totalSupply: Int, percentChangeHour: Double, percentChangeDay: Double,
        percentChangeWeek: Double, lastUpdated: Int) {
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

    func statusMessage() -> String {
        print(self.percentChangeHour)
        print(self.percentChangeDay)
        print(self.percentChangeWeek)
        return "\(self.rank)) \(self.name)/\(self.symbol):"
            + "   USD: $\(self.priceUSD.formattedWithPoints)"
            + " | BTC: \(self.priceBTC.formattedWithPoints)"
            + "  / Change (24h): \(self.percentChangeDay)%,  (7d): \(self.percentChangeWeek)%"
            + "  / Market Cap: $\(self.marketCapUSD.formattedWithPoints)"
    }

    func detailMessage() -> String {
        print(self.percentChangeHour)
        print(self.percentChangeDay)
        print(self.percentChangeWeek)
        return "\(self.rank)) \(self.name)/\(self.symbol):"
            + "   USD: $\(self.priceUSD.formattedWithPoints)"
            + " | BTC: \(self.priceBTC.formattedWithPoints)"
            + "  / Change (1h): \(self.percentChangeHour)%,  (24h): \(self.percentChangeDay)%,  (7d): \(self.percentChangeWeek)%"
            + "  / 24h Volume USD: $\(self.dayVolumeUSD.formattedWithPoints)"
            + "  / Market Cap: $\(self.marketCapUSD.formattedWithPoints)"
            + "  / Available Supply: \(self.availableSupply.formattedWithPoints) \(self.symbol)"
            + "  / Circulating Supply: \(self.totalSupply.formattedWithPoints) \(self.symbol)"
    }
}
