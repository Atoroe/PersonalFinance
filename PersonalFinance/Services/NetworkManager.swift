//
//  NetworkManager.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 28.09.21.
//

import Foundation
import CryptoKit

enum URLS: String {
    case rocketSMSPostRequest = "http://api.rocketsms.by/simple/send"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let login = "192960913"
    private let passwordMD5Hash = "bc83cabbc655f83451d3985f53b87f72"
    
    private init() {}
    
    //MARK: - POST to RocketSMS
    func postRequestToRocketSMS(phone: String, message: String, with complition: @escaping (Result<[String:Any], Error>) -> Void) {
        let url = "\(URLS.rocketSMSPostRequest.rawValue)?username=\(login)&password=\(passwordMD5Hash)&phone=\(phone)&text=\(message)"
        //let url = "\(URLS.rocketSMSPostRequest.rawValue)?username=\(login)&password=\(passwordMD5Hash)"
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            print(response)
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                DispatchQueue.main.async {
                    complition(.success(json))
                }
            } catch {
                complition(.failure(error))
            }
        }.resume()
    }
}

