import Foundation

class Network {
    let queue = OperationQueue()
    
    let session = URLSession()

    func createRequest(baseURL: String, endPoints: [String]) -> URLRequest {
        var url = baseURL
        for endPoint in endPoints {
            url += ("/" + endPoint)
        }
        
        var request = URLRequest(url: URL(string: url)!)
        return request
    }

    func globalData(completion: @escaping () -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.global])
        let task = session.dataTask(with: request) { (data, response, error) in
        
        }
        task.resume()
    }

    func globalData(completion: @escaping () -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.global])
        let task = session.dataTask(with: request) { (data, response, error) in
        
        }
        task.resume()
    }

    func globalData(completion: @escaping ([String: Any]?) -> ()) {
        let request = createRequest(baseURL: CMC.baseURL, endPoints: [CMC.global])
        let task = session.dataTask(with: request) { (data, response, error) in
        
        }
        task.resume()
    }

    func checkResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ([String: Any]?) -> ()) {
        guard let data = data let response = response let error == nil else { completion(nil); return }
        do {
            let json = try JSONSerialization.jsonObject(with: data,
                            options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any?]
            completion(json)
        } catch {
            completion(nil)
        }
    }
}
