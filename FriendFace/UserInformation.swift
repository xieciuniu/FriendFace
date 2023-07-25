//
//  UserInformation.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import Foundation

struct Friend: Codable, Identifiable {
    var id: String
    var name: String
    
    static let example = Friend(id: "id", name: "name")
}

struct User: Codable, Identifiable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    static let example = User(id: "id", isActive: true, name: "name", age: 19, company: "best", email: "@email", address: "street", about: "about me", registered: Date.now, tags: ["potato"], friends: [Friend.example])
}
