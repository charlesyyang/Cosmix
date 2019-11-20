//
//  Song.swift
//  MusicApp
//
//  Created by Charles Yang on 11/16/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation

class Song {
    
    let id: String!
    let title: String!
    let artist: String!
    let album: String!
    
    init(title: String, artist: String) {
        self.id = ""
        self.title = title
        self.artist = artist
        self.album = ""
    }
    
    init(id: String, title: String, artist: String, album: String) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
    }
}
