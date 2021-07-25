//
//  Worker.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import UIKit
import RxSwift

class Worker {
    func doGetWeather(query: String) -> Observable<DispleyedElement> {
        return NetworkManager.requestGetWeather(userInfo: ["access_key" : apiKey ,"query" : query])
    }
}
