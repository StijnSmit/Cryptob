import CoreFoundation
import Dispatch
import Foundation
import SwiftDiscord

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

// MARK: - UTILITY
// CoinMarketCap:
struct CMC {
    static let baseURL = "https://api.coinmarketcap.com/v1/"
}

struct CMCGlobalData {
    var totalMarketCap: Int
    var todayVolume: Int
    var bitcoinPercentage: Double
    var activeCurrencies: Int
    var activeAssets: Int
    var activeMarkets: Int
    var lastUpdated: Int

    enum CodingKeys: String {
        case totalMarketCap = "total_market_cap_usd"
        case todayVolume = "total_24h_volume_usd"
        case bitcoinPercentage = "bitcoin_percentage_of_market_cap"
        case activeCurrencies = "active_currencies"
        case activeAssets = "active_assets"
        case activeMarkets = "active_markets"
        case lastUpdated = "last_updated"
    }

    init() {
        self.totalMarketCap = 0
        self.todayVolume = 0
        self.bitcoinPercentage = 0
        self.activeCurrencies = 0
        self.activeAssets = 0
        self.activeMarkets = 0
        self.lastUpdated = 0
    }

    init(totalMarketCap: Int, todayVolume: Int, bitcoinPercentage: Double, activeCurrencies: Int, activeAssets: Int, activeMarkets: Int, lastUpdated: Int) {
        self.totalMarketCap = totalMarketCap
        self.todayVolume = todayVolume
        self.bitcoinPercentage = bitcoinPercentage
        self.activeCurrencies = activeCurrencies
        self.activeAssets = activeAssets
        self.activeMarkets = activeMarkets
        self.lastUpdated = lastUpdated
    }

    init(json: [String: Any]) {
        if let totalMarketCap = json[CodingKeys.totalMarketCap.rawValue] as? Int { print(totalMarketCap) } else { print("Error Total") }
        if let todayVolume = json[CodingKeys.todayVolume.rawValue] as? Int { print(todayVolume) } else { print("Error VOlume") }
        if let bitcoinPercentage = json[CodingKeys.bitcoinPercentage.rawValue] as? Double { print(bitcoinPercentage) } else { print("Error Bitcoin") }
        if let activeCurrencies = json[CodingKeys.activeCurrencies.rawValue] as? Int { print(activeCurrencies) } else { print("Error currencies") }
        if let activeAssets = json[CodingKeys.activeAssets.rawValue] as? Int { print(activeAssets) } else { print("Error assets") }
        if let activeMarkets = json[CodingKeys.activeMarkets.rawValue] as? Int { print(activeMarkets) } else { print("Error markets") }
        if let lastUpdated = json[CodingKeys.lastUpdated.rawValue] as? Int { print(lastUpdated) } else { print("Error Updated") }
        guard let totalMarketCap = json[CodingKeys.totalMarketCap.rawValue] as? Int,
            let todayVolume = json[CodingKeys.todayVolume.rawValue] as? Int,
            let bitcoinPercentage = json[CodingKeys.bitcoinPercentage.rawValue] as? Double,
            let activeCurrencies = json[CodingKeys.activeCurrencies.rawValue] as? Int,
            let activeAssets = json[CodingKeys.activeAssets.rawValue] as? Int,
            let activeMarkets = json[CodingKeys.activeMarkets.rawValue] as? Int,
            let lastUpdated = json[CodingKeys.lastUpdated.rawValue] as? Int else {
                print("CAN'T PARSE THE JSON!!!!!")
                self.init()
                return
            }
        self.init(totalMarketCap: totalMarketCap, todayVolume: todayVolume,
        bitcoinPercentage: bitcoinPercentage, activeCurrencies: activeCurrencies,
        activeAssets: activeAssets, activeMarkets: activeMarkets, lastUpdated: lastUpdated)
    }

    static func globalData(completion: @escaping (CMCGlobalData?, Error?) -> ()) {
        guard let url = URL(string: CMCGlobalData.endpoint()) else { print("Can't Make URL"); return }
        let urlRequest = URLRequest(url: url)
        print("URL: \(url)")
        print("URLRequest: \(urlRequest)")
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            print("Returned from request")
            guard error == nil else {
                print("Error")
                completion(nil, error)
                return
            } 
            guard let responseData = data else { print("Error: did not receivedata")
                let error = BackendError.objectSerialization(reason: "No data in response")
                completion(nil, error)
                return
            }
            do {
                print("DO")
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("JSON") 
                    print(json)
                    let globalData = CMCGlobalData(json: json)
                    print(globalData)
                    completion(globalData, nil)
                } else {
                    print("Couldn't create GlobalData")
                    let error = BackendError.objectSerialization(reason: "Couldn't create a GlobalData object from the JSON")
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
                return
            }

        })
        task.resume()
    }

    /*
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let totalMarketCap = try values.decode(Int.self, forKey: .totaMarketCap)
        let todayVolume = try values.decode(Int.self, forKey: .todayVolume)
        let bitcoinPercentage = try values.decode(Double.self, forKey: .bitcoinPercentage)
        let activeCurrencies = try values.decode(Int.self, forKey: .activeCurrencies)
        let activeAssets = try values.decode(Int.self, forKey: .activeAssets)
        let activeMarkets = try values.decode(Int.self, forKey: .activeMarkets)
        let lastUpdated = try values.decode(Int.self, forKey: .lastUpdated)
        self.init(totalMarketCap: totalMarketCap, todayVolume: todayVolume, bitcoinPercentage: bitcoinPercentage, activeCurrencies: activeCurrencies, activeAssets: activeAssets, activeMarkets: activeMarkets, lastUpdated: lastUpdated) 
    }
    */

    static func endpoint() -> String {
        return CMC.baseURL + "global/"
    }
}



class Shard: DiscordClientDelegate {
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
            let message2 = DiscordMessage(content:"Market Cap: $\(globalData.totalMarketCap)  / 24h Vol: $\(globalData.todayVolume)  / BTC Dominance: \(globalData.bitcoinPercentage) %" , embed: nil)
            message.channel?.send(message2)
        }
        if message.content == "$mycommand" {
            let message2 = DiscordMessage(content: "Market Cap: $\(globalData.totalMarketCap)")
            message.channel?.send(message2)
        }
        if message.content == "$test" {
            let message2 = DiscordMessage(content: "SADASDASD")
            message.channel?.send(DiscordMessage(content: "asd asdasd"))
        }
        if message.content == "$net" {
            message.channel?.send("ASDASD")
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

let queue = DispatchQueue(label: "Async Read")
let bot = Shard()
bot.createGlobalData()
bot.connect()

CFRunLoopRun()
