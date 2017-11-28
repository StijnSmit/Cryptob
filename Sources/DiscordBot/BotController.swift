//
//  BotController.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation
import SwiftDiscord

class BotController: DiscordClientDelegate, CommandHandler {
   var client: DiscordClient!
   var cmcController: CMCController!
   
   init() {
      self.client = DiscordClient(token: token, delegate: self, configuration: [.log(.info)])
      self.cmcController = CMCController()
   }
   
   func connect() {
      self.client.connect()
   }
   
   func client(_ client: DiscordClient, didConnect connected: Bool) {
      print("Bot Connected!")
   }
   
   func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
       guard message.content.hasPrefix("!") else { return }

       let commandArgs = String(message.content.dropFirst()).components(separatedBy: " ")
       let command = commandArgs[0]

       handleCommand(command.lowercased(), with: Array(commandArgs.dropFirst()), message: message)
   }

   func handleCommand(_ command: String, with arguments: [String], message: DiscordMessage) {
        print("got command: \(command)")

/*        if let guild = message.channel?.guild, ignoreGuilds.contains(guild.id), !userOverrides.contains(message.author.id) {
            print("Ignoring this guild")
            return
        }
        */

        guard let command = Command(rawValue: command.lowercased()) else { return }
        
        switch command {
        case .market:
            handleMarket(with: arguments, message: message)
        case .ticker:
            handleTicker(with: arguments, message: message)
        default:
            print("Bad command \(command)")
        }
   }

   func handleMarket(with arguments: [String], message: DiscordMessage) {
       let response = cmcController.globalDataMessage()
        message.channel?.send(DiscordMessage(content: response))
   }

   func handleTicker(with arguments: [String], message: DiscordMessage) {
       let response = cmcController.tickerMessage(ticker: "TEST")
        message.channel?.send(DiscordMessage(content: response))
   }
}
