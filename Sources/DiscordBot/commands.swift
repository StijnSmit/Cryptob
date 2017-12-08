import Foundation 
import SwiftDiscord 

enum Command: String {
    case market = "market"
    case status = "status"
    case detail = "detail"
}

protocol CommandHandler {
    func handleCommand(_ command: String, with arguments: [String], message: DiscordMessage) 
}
