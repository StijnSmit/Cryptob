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

    func globalData(completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.global])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkGlobalDataResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func ticker(name: String, completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.ticker, name])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkTickerResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func allTickers(completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.ticker])
        let task = session.dataTask(with: request) { (data, response, error) in
            self.checkTickerResponse(data: data, response: response, error: error, completion: completion) 
        }
        task.resume()
    }

    func checkGlobalDataResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ([String: Any]?) -> ()) {
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
}
