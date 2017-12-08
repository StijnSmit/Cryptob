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
   var dayVolumeUSD: Int?
   var marketCapUSD: Int?
   var availableSupply: Int?
   var totalSupply: Int?
   var percentChangeHour: Double?
   var percentChangeDay: Double?
   var percentChangeWeek: Double?
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
      guard let id = json[CodingKeys.id.rawValue] as? String,
            let name = json[CodingKeys.name.rawValue] as? String,
            let symbol = json[CodingKeys.symbol.rawValue] as? String,
            let sRank = json[CodingKeys.rank.rawValue] as? String,
            let rank = Int(sRank),
            let sPriceUSD = json[CodingKeys.priceUSD.rawValue] as? String,
            let priceUSD = Double(sPriceUSD),
            let sPriceBTC = json[CodingKeys.priceBTC.rawValue] as? String,
            let priceBTC = Double(sPriceBTC),
            let sLastUpdated = json[CodingKeys.lastUpdated.rawValue] as? String,
            let lastUpdated = Int(sLastUpdated) else {
            return nil
      }
        var dayVolumeUSD: Int? = nil
        if let sDayVolumeUSD = json[CodingKeys.dayVolumeUSD.rawValue] as? String {
            dayVolumeUSD = Int(Double(sDayVolumeUSD)!)
        }

        var marketCapUSD: Int? = nil
        if let sMarketCapUSD = json[CodingKeys.marketCapUSD.rawValue] as? String {
            marketCapUSD = Int(Double(sMarketCapUSD)!)
        }

        var availableSupply: Int? = nil
        if let sAvailableSupply = json[CodingKeys.availableSupply.rawValue] as? String {
            availableSupply = Int(Double(sAvailableSupply)!)
        }

        var totalSupply: Int? = nil
        if let sTotalSupply = json[CodingKeys.totalSupply.rawValue] as? String {
            totalSupply = Int(Double(sTotalSupply)!)
        }

        var percentChangeHour: Double? = nil
        if let sPercentChangeHour = json[CodingKeys.percentChangeHour.rawValue] as? String {
            percentChangeHour = Double(sPercentChangeHour)
        }

        var percentChangeDay: Double? = nil
        if let sPercentChangeDay = json[CodingKeys.percentChangeDay.rawValue] as? String {
            percentChangeDay = Double(sPercentChangeDay)
        }

        var percentChangeWeek: Double? = nil
        if let sPercentChangeWeek = json[CodingKeys.percentChangeWeek.rawValue] as? String {
            percentChangeWeek = Double(sPercentChangeWeek)
        }

      self.init(id: id, name: name, symbol: symbol, rank: rank, priceUSD: priceUSD, priceBTC: priceBTC,
          dayVolumeUSD: dayVolumeUSD, marketCapUSD: marketCapUSD, availableSupply: availableSupply,
          totalSupply: totalSupply, percentChangeHour: percentChangeHour, percentChangeDay: percentChangeDay,
          percentChangeWeek: percentChangeWeek, lastUpdated: lastUpdated)
   }
   
   init(id: String, name: String, symbol: String, rank: Int, priceUSD: Double, priceBTC: Double, dayVolumeUSD: Int?,
        marketCapUSD: Int?, availableSupply: Int?, totalSupply: Int?, percentChangeHour: Double?, percentChangeDay: Double?,
        percentChangeWeek: Double?, lastUpdated: Int) {
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
        var message = "\(self.rank)) \(self.name)/\(self.symbol):"
        message += "   USD: $\(self.priceUSD.formattedWithPoints)"
        message += " | BTC: \(self.priceBTC.formattedWithPoints)"
        if let day = self.percentChangeDay, let week = self.percentChangeWeek {
            message += "  / Change (24h): \(day)%,  (7d): \(week)%"
        }
        if let cap = self.marketCapUSD { 
            message += "  / Market Cap: $\(cap.formattedWithPoints)"
        }

        return message
    }

    func detailMessage() -> String {
        var message = "\(self.rank)) \(self.name)/\(self.symbol):"
        message += "   USD: $\(self.priceUSD.formattedWithPoints)"
        message += " | BTC: \(self.priceBTC.formattedWithPoints)"

        if let hour = self.percentChangeHour, let day = self.percentChangeDay, let week = self.percentChangeWeek {
            message += "  / Change (1h): \(hour)%,  (24h): \(day)%,  (7d): \(week)%"
        }

        if let volume = self.dayVolumeUSD {
            message += "  / 24h Volume USD: $\(volume.formattedWithPoints)"
        }

        if let cap = self.marketCapUSD {
            message += "  / Market Cap: $\(cap.formattedWithPoints)"
        }

        if let available = self.availableSupply {
            message += "  / Available Supply: \(available.formattedWithPoints) \(self.symbol)"
        }

        if let total = self.totalSupply {
            message += "  / Circulating Supply: \(total.formattedWithPoints) \(self.symbol)"
        }

        return message
    }
}
