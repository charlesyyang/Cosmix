//
//  AddPlaylistsViewController.swift
//  MusicApp
//
//  Created by shaina on 11/20/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class AddPlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PlaylistsTableView: UITableView!
    var playlists = [Playlist]()
    var selectedPlaylists = Set<String>()
    var isSelectAll = true
    var selectedPlaylist: Playlist = Playlist(id: "", imageURL: "", name: "")
    @IBOutlet weak var selectAllButton: UIButton!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    var spotifyToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaylistsTableView.delegate = self
        PlaylistsTableView.dataSource = self
        spotifyToken = delegate.accessToken
        getPlaylists()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PlaylistsTableView.reloadData()
    }
    
    
    @IBAction func selectDeselectTogglePressed(_ sender: Any) {
        if isSelectAll {
            for playlist in playlists {
                if !selectedPlaylists.contains(playlist.name) {
                    selectedPlaylists.insert(playlist.name)
                }
            }
            selectAllButton.titleLabel?.text = "Deselect All"
        } else {
            selectedPlaylists.removeAll()
            selectAllButton.titleLabel?.text = "Select All"
        }
        isSelectAll = !isSelectAll
    }
    
    
    func getPlaylists() {
            print("get playlists")
            print("spotify token", spotifyToken)
            guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/playlists") else {
                           return
                       }
            if spotifyToken == "" {
                return
            }
        var param = ["service": "spotify", "token": spotifyToken]
            
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
                               var id = entry["id"]
                               var img = entry["image"]
                                var playlistName = entry["name"]
                                
                                if id == "" {
                                    id = "n/a"
                                }
                                if img == "" {
                                    img = "n/a"
                                }
                                if playlistName == "" {
                                    playlistName = "n/a"
                                }
                                let newPlaylist = Playlist(id: id!, imageURL: img!, name: playlistName!)
                                self.playlists.append(newPlaylist)
                                print("playlist name", playlistName)
                            }
                        }
    //                    print("mix size: ", self.mix.count)
    //                    let idsuccess = JSON["result"] as! Bool
     //                   if idsuccess {
     //                       print("successsss!!!!")
     //                   } else {
     //                   }
                        self.PlaylistsTableView.reloadData()
                        print("finished reloading mixes table")
                        print("mixes table size: ", self.PlaylistsTableView.numberOfSections)
                }
     
                case .failure(let error):
                    break
            }
            }

        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaylist = playlists[indexPath.row]

        if !selectedPlaylists.contains(selectedPlaylist.name) {
            selectedPlaylists.insert(selectedPlaylist.name)
        }
    }
    
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return playlists.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     if let cell = tableView.dequeueReusableCell(withIdentifier: "playlistTableCell") as? PlaylistTableViewCell {
         let playlist = playlists[indexPath.row]
        cell.playlistName.text = playlist.name
        cell.playlistImg.image = playlist.image
        print("cell name", cell.playlistName.text)
         return cell
     }
     
     return UITableViewCell()
 }
}

