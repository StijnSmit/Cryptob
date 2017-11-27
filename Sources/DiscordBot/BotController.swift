//
//  BotController.swift
//  DiscordBot
//
//  Created by Stijn Smit on 27-11-17.
//

import Foundation
import SwiftDiscord

class BotController: DiscordClientDelegate {
   var client: DiscordClient!
   var globalData: CMCGlobalData!
   
   init() {
      self.client = DiscordClient(token: token, delegate: self, configuration: [.log(.info)])
   }
   
   func connect() {
      self.client.connect()
   }
   
   func client(_ client: DiscordClient, didConnect connected: Bool) {
      print("Bot Connected!")
   }
   
   func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
      if message.content == "!market" {
         let discordMessage = DiscordMessage(content: "", embed: nil)
         message.channel?.send(discordMessage)
      }
   }
   
   func createGlobalData() {
      CMCGlobalData.globalData() { (globalData, error) in
         guard let globalData = globalData, error == nil else {
            self.globalData = CMCGlobalData()
            return
         }
         self.globalData = globalData
      }
   }
}
