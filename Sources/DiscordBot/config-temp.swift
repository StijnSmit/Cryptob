import Foundation
import SwiftDiscord

// MARK: - CONFIG
public let token = "Bot TOKEN" as DiscordToken

enum BackendError: Error {
   case urlError(reason: String)
   case objectSerialization(reason: String)
}
