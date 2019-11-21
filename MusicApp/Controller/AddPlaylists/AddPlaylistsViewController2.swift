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
    var playlists = [String]()
    var selectedPlaylists = Set<String>()
    var isSelectAll = true
    var selectedPlaylist = ""
    @IBOutlet weak var selectAllButton: UIButton!
    
    
    var spotifyToken: String = "BQD40iVpafeCnEpAcUhekID74QPZV_En-nWm9Id_KMAAe29ZPWQCjiUwytKxZDA2EspmsLW889P-NmyHb-8LvQkyirrrUCIjDexyEae-SNmkNRB5x-Y_Wzbq51b5cEiBCPBCxFbAZ-39D3izcygFn5_dWuC4eHir9bwE9ANYTp7fLVpyVLo4shIz1IYSOvy5PdZTqhYjRCkT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaylists()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectDeselectTogglePressed(_ sender: Any) {
        if isSelectAll {
            for playlist in playlists {
                if !selectedPlaylists.contains(playlist) {
                    selectedPlaylists.insert(playlist)
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
                                print("running inside loop")
                               var artist = entry["artist"]
                               var name = entry["name"]
                                if name == "" {
                                    name = "n/a"
                                }
                                if artist == "" {
                                    artist = "n/a"
                                }
                               var newPlaylist = name
                                if newPlaylist == "" {
                                    newPlaylist = "n/a"
                                }
                                self.playlists.append(newPlaylist!)
                                print("artist")
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

        if !selectedPlaylists.contains(selectedPlaylist) {
            selectedPlaylists.insert(selectedPlaylist)
        }
    }
    
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return playlists.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? PlaylistTableViewCell {
         let playlist = playlists[indexPath.row]
         cell.playlistName.text = playlist
         return cell
     }
     
     return UITableViewCell()
 }
}

