//
//  Mix.swift
//  MusicApp
//
//  Created by Charles Yang on 11/9/19.
//  Copyright © 2019 shaina. All rights reserved.
//


import Foundation

class Mix {
    
    
    let name: String!
    let id: String!
    let tracks: [String]!
    let numberofUsers: Int!
    let users: [String]!
    
    
    init(name: String, id: String, tracks: [String], numberofUsers: Int, users: [String]) {
        self.name = name
        self.id = id
        self.tracks = tracks
        self.numberofUsers = numberofUsers
        self.users = users
        
    }






}
