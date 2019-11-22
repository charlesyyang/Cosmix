//
//  Playlist.swift
//  MusicApp
//
//  Created by shaina on 11/21/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation

class Playlist {
    var id: String!
    var image: UIImage!
    var name: String!
    
    init(id: String, imageURL: String, name: String) {
        self.id = id
        self.name = name
        guard let url = URL(string: imageURL) else {
            return }
        
        if let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)
        } //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    }
    
    //async image fetch -- CURRENTLY NOT USING
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
                self.image = UIImage(data: data)
            }
        }
    }
    
}
