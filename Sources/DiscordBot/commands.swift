import Foundation 
import SwiftDiscord 

enum Command: String {
    case market = "market"
    case ticker = "status"
}

protocol CommandHandler {
    func handleCommand(_ command: String, with arguments: [String], message: DiscordMessage) 
}
