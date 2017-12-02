import CoreFoundation
import Dispatch
import Foundation

struct CMCSymbolStorage {
    var symbols: [String: [String]]

    init() {
        self.symbols = [String:[String]]()
    }

    func fetchLatestSymbols() {
        
    }

    func getSymbol(for key: String) -> String? {
        let symbol = symbols.filter { $0.1.contains(key) }.first?.0 
        if let symbol = symbol {
            return symbol
        }
        return nil
    }
}
