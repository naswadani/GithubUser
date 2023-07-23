//
//  User.swift
//  GithubUser
//
//  Created by naswakhansa on 22/07/23.
//

import Foundation

struct User:Codable{
    let login : String
    let avatar_url : String
    let url : URL
}
struct Followers{
    let login : String
    let avatar_url : URL
}
struct Following{
    let login : String
    let avatar_url:URL
}
