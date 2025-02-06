//
//  NetworkManager.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/16/25.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    func request<T: Decodable>(url: String, headers: HTTPHeaders, T: T.Type ,completion: @escaping (T) -> Void) {
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
                
            case.success(let value):
                completion(value.self)
            case.failure(let error) :
                print(error)
                print(url)
                print(response.response?.statusCode)
            }
        }
    }
    
}

