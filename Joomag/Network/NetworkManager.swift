//
//  NetworkManager.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import UIKit
import RxSwift

class NetworkManager {
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    //MARK: - Region
    static func requestGetWeather(userInfo: [String:Any]) -> Observable<DispleyedElement>
    {
        let originalString = SERVER_URL + API_CURRENT + "?" + getPostString(params: userInfo)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")!
        let networkAPI = NetworkAPI(baseUrl: url)
        return networkAPI.getUsersQuery()
    }
    
  
}
