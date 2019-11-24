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
    var img: UIImage!
    let imgURL: String!
    
    init(uri: String, title: String, artist: String, imageUrl: String) {
        self.id = uri
        self.title = title
        self.artist = artist
        self.album = ""
        self.imgURL = imageUrl
        
        guard let url = URL(string: imgURL) else {
                  return }
              
              if let data = try? Data(contentsOf: url) {
                  img = UIImage(data: data)
              } //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.img = UIImage(data: data)
            }
        }
    }
    
}
