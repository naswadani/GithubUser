//
//  apiCall.swift
//  GithubUser
//
//  Created by naswakhansa on 22/07/23.
//

import Foundation
class apiCall {
    func getUsers(username: String, completion: @escaping ([User]?) -> ()) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let users = try JSONDecoder().decode(User.self, from: data)
                completion([users])
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
