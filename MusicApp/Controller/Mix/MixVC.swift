//
//  MixVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/11/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MixVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var mix = [Song]()
    var selectedSong: Song!
    var spaceID: String!
    @IBOutlet weak var MixesTableView: UITableView!
    
    @IBOutlet weak var SpaceIDLabel: UILabel!
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    @IBOutlet weak var CurrentSongLabel: UILabel!
    
    @IBOutlet weak var CurrentSongArtist: UILabel!
    
    @IBOutlet weak var CurrentSongImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MixesTableView.delegate = self
        MixesTableView.dataSource = self
        setUpLogic()
        getFilteredSongs()
        // Do any additional setup after loading the view.
    }
    
    func setUpLogic() {
        if spaceID == "" {
            spaceID = "Unknown Party"
        }
        SpaceIDLabel.text = spaceID
        var spaceIDList = [String]()
        
        if (UserDefaults.standard.array(forKey: "spaces") != nil) {
            spaceIDList = UserDefaults.standard.array(forKey: "spaces") as! [String]
        }
        if !spaceIDList.contains(spaceID) {
            spaceIDList.append(spaceID)
            UserDefaults.standard.set(spaceIDList, forKey: "spaces")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MixesTableView.reloadData()
    }
    
    func getFilteredSongs() {
        print("get filtered songs")
        print("spaceId", spaceID)
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/get_facts_list") else {
                       return
                   }
        if spaceID == "" {
            return
        }
        var param = ["id": spaceID]
        
        AF.request(url, parameters: param).validate().responseJSON { response in
        print(response.request)  // original URL request
        print(response.response) // URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization
        
        switch response.result {
            case .success(let value) :
                if let JSON = value as? NSArray {
                    for jsonEntry in JSON {
                        if let entry = jsonEntry as? [String: String] {
                           var artist = entry["artist"]
                           var name = entry["name"]
                            if name == "" {
                                name = "n/a"
                            }
                            if artist == "" {
                                artist = "n/a"
                            }
                           let newSong = Song(title: name!, artist: artist!)
                            print("artist", artist)
                            self.mix.append(newSong)
                        }
                    }
                    print("mix size: ", self.mix.count)
//                    let idsuccess = JSON["result"] as! Bool
 //                   if idsuccess {
 //                       print("successsss!!!!")
 //                   } else {
 //                   }
                    self.MixesTableView.reloadData()
                    print("finished reloading mixes table")
                    print("mixes table size: ", self.MixesTableView.numberOfSections)
                }
 //
            case .failure(let error):
                break
        }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("running table view count")
        return mix.count
    }
    
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("running cell for row")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MixTableViewCell {
            let song = mix[indexPath.row]
            cell.mixID.text = song.artist
            cell.mixName.text = song.title
            print("setting cell info")
            print("cell text", cell.mixID.text)

            return cell
        }
        
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedSong = mix[indexPath.row]
        CurrentSongLabel.text = selectedSong.title
        CurrentSongArtist.text = selectedSong.artist
    }
}
    

