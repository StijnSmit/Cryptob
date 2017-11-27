//
//  Utility.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation

extension Formatter {
   static let decimalPoints: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.groupingSeparator = "."
      formatter.numberStyle = .decimal
      return formatter
   }()
}

extension Integer {
   var formattedWithPoints: String {
      return Formatter.decimalPoints.string(for: self) ?? ""
   }
}

public let hour: Double = 3600
public let day: Double = 86400
public let week: Double = 604800
