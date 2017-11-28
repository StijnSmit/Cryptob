import Foundation

let queue = DispatchQueue(label: "Async Read")

let bot = BotController()

bot.connect()

CFRunLoopRun()
