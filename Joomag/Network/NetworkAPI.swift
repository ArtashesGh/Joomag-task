//
//  NetworkAPI.swift
//  Joomag
//
//  Created by Artashes Nok Nok on 3/20/21.
//

import Foundation
import RxSwift

struct NetworkAPI {
    var baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    struct GetWeatherResult: Codable {
        var error: Err?
        var request: Request?
        var location: Location?
        var current: Current?
        
    }
    func getUsersQuery() -> Observable<DispleyedElement> {
        return Observable<DispleyedElement>.create { obs in
            var request = URLRequest(url: baseUrl)
            request.httpMethod = "GET"
           
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let tsk = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard error == nil else {
                    obs.onError(error!)
                    return
                }
                
                guard data != nil else {
                    print("Protocol error: no data received")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response"])
                    obs.onError(error)
                    return
                }
                
                do {
                    let res = try JSONDecoder().decode(GetWeatherResult.self, from: data!)
                    if res.error != nil {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])
                        obs.onError(error)
                    } else {
                        if res.current != nil {
                            let dispElement = DispleyedElement(temperature: res.current?.temperature,
                                                               weatherIcons: res.current?.weatherIcons?.first,
                                                               weatherDescriptions: res.current?.weatherDescriptions?.first,
                                                               windSpeed: res.current?.windSpeed,
                                                               name: res.location?.name)
                            
                            obs.onNext(dispElement)
                            obs.onCompleted()
                        }
                    }
                } catch let err {
                    print("Format error: \(err)")
                    obs.onError(err)
                }
            })
            tsk.resume()
            return Disposables.create{ tsk.cancel() }
        }
    }

}
