import CoreFoundation
import Dispatch
import Foundation

struct CMCSymbolStorage {
   struct CMCSymbol {
      var id: String
      var name: String
      var symbol: String
      
      enum CodingKeys: String {
         case id = "id"
         case name = "name"
         case symbol = "symbol"
      }
      
      init?(json: [String: Any]) {
         print(json)
         guard let id = json[CodingKeys.id.rawValue] as? String,
            let name = json[CodingKeys.name.rawValue] as? String,
            let symbol = json[CodingKeys.symbol.rawValue] as? String else {
               return nil
         }
         self.init(id: id, name: name, symbol: symbol)
      }
      
      init(id: String, name: String, symbol: String) {
         self.id = id
         self.name = name
         self.symbol = symbol
      }
   }
      
    var network: Network
    var symbols: [String: [String]]

      init(network: Network) {
         self.network = network
        self.symbols = [String:[String]]()
    }

    func fetchLatestSymbols() {
      var preSymbols: [String: [String]]
      DispatchQueue.global().async {
         self.network.allTickers() { (json) in
            guard let tickers = json as? [[String: Any]] else { completion(nil); return }
            for ticker in tickers {
               if let symbol = CMCSymbol(json: json) {
                  preSymbols[symbol.id] = [symbol.id, symbol.name, symbol.symbol]
               }
            }
            DispatchQueue.main.async {
               self.symbols = preSymbols
            }
         }
      }
    }

    func getSymbol(for key: String) -> String {
        let symbol = symbols.filter { $0.1.contains(key) }.first?.0 
        if let symbol = symbol {
            return symbol
        }
        return key
    }
}
