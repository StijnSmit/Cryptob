import Foundation

class Network {
    let queue = OperationQueue()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func createRequest(baseURL: String, endPoints: [String]) -> URLRequest {
        var url = baseURL
        for endPoint in endPoints {
            url += ("/" + endPoint)
        }
        
        let request = URLRequest(url: URL(string: url)!)
        return request
    }
   
   func createRequest(baseURL: String, endPoints: [String], parameters: [String: Any]) -> URLRequest {
      var url = baseURL
      for endPoint in endPoints {
         url += ("/" + endPoint)
      }
      var urlComponents = URLComponents(string: url)!
      for parameter in parameters {
         if let value = parameter.value as? Int {
            urlComponents.queryItems = [URLQueryItem(name: parameter.key, value: value)]
         }
      }
      
      let request = URLRequest(url: urlComponents.url!)
      return request
   }

    func globalData(completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.global])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkGlobalDataResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func ticker(symbol: String, completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.ticker, symbol])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkTickerResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func allTickers(completion: @escaping ([[String: Any]]?) -> ()) {
      let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.ticker], parameters: ["limit": 0])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkTickerResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func checkGlobalDataResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ([[String: Any]]?) -> ()) {
        if let _ = error {
            completion(nil)
            return
        }
        guard let data = data, let _ = response else { completion(nil); return }
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            do {
                let json = try JSONSerialization.jsonObject(with: data,
                                options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any?]
                completion(json)
            } catch {
                completion(nil)
            }
        } else { completion(nil) }
    }
   
    func checkTickerResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ([String: Any]?) -> ()) {
        if let _ = error {
            completion(nil)
            return
        }
        guard let data = data, let _ = response else { completion(nil); return }
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            do {
                let json = try JSONSerialization.jsonObject(with: data,
                                options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any?]]
                completion(json.first)
            } catch {
                print("ERROR")
                completion(nil)
            }
        } else { completion(nil) }
    }
   
   func checkAllTickersResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ([[String: Any]]?) -> ()) {
      if let _ = error {
         completion(nil)
         return
      }
      guard let data = data, let _ = response else { completion(nil); return }
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
         do {
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any?]]
            completion(json)
         } catch {
            print("ERROR")
            completion(nil)
         }
      } else { completion(nil) }
   }
}
