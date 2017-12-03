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
   var network: Network!
   
   init() {
      self.client = DiscordClient(token: token, delegate: self, configuration: [.log(.info)])
      self.network = Network()
      self.cmcController = CMCController(network: network)
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
       cmcController.globalDataMessage() { response in 
           guard let response = response else { 
                message.channel?.send(DiscordMessage(content: "Error"))
                return
           }
            message.channel?.send(DiscordMessage(content: response))
       }
   }

   func handleTicker(with arguments: [String], message: DiscordMessage) {
       cmcController.tickerMessage(input: arguments) { response in 
            guard let response = response else {
                message.channel?.send(DiscordMessage(content: "Unknown"))
                return
            }
            message.channel?.send(DiscordMessage(content: response))
       }
   }
}
