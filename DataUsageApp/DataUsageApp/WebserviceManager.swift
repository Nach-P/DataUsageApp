//
//  WebserviceManager.swift
//  DataUsageApp
//
//  Created by Nach on 7/3/20.
//

import Foundation

class WebserviceManager {
    
    static func fetchData(urlString: String ,completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
