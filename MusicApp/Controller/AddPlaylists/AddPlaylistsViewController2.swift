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
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    @IBOutlet weak var PlaylistsTableView: UITableView!
    var playlists = [Playlist]()
    var selectedPlaylists = [String]()
    var isSelectAll = true
    var failedPlaylists = [String]()
    var selectedPlaylist: Playlist = Playlist(id: "", imageURL: "", name: "")
    @IBOutlet weak var selectAllButton: UIButton!
    
    @IBOutlet weak var addPlaylistsButton: UIButton!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var partyID: String!
    var spotifyToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaylistsTableView.delegate = self
        PlaylistsTableView.dataSource = self
        PlaylistsTableView.allowsMultipleSelection = true
        PlaylistsTableView.allowsMultipleSelectionDuringEditing = true
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
                    selectedPlaylists.append(playlist.name)
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
            selectedPlaylists.append(selectedPlaylist.name)
        } else {
            selectedPlaylists = selectedPlaylists.filter {$0 != selectedPlaylist.name}
        }
        print("selected playlists: ")
        
        for selectedPlaylist in selectedPlaylists {
            print("playlist: ", selectedPlaylist)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedPlaylist = playlists[indexPath.row]

        selectedPlaylists = selectedPlaylists.filter {$0 != selectedPlaylist.name}
        print("selected playlists: ")
        
        for selectedPlaylist in selectedPlaylists {
            print("playlist: ", selectedPlaylist)
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
    
    
    @IBAction func addPlaylistsButtonPressed(_ sender: Any) {
        self.createSpinnerView()
        for (index, playlist) in selectedPlaylists.enumerated() {
            let myPlaylist = findPlaylist(playlistName: playlist)
            if myPlaylist.name == "" {
                break
            }
            let parameters = ["id": partyID, "playlist": myPlaylist.id, "token": spotifyToken]
            print("playlist id in add playlists: ", myPlaylist.id)
            guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/add") else {
                return
            }
             //Alamofire request to check party ID
            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
                switch response.result {
                case .success(_) :
                    print("added playlist to party: ", myPlaylist.name)
                    if (response.response?.statusCode == 500) {
                        self.failedPlaylists.append(myPlaylist.name)
                    }
                    if index == self.selectedPlaylists.endIndex - 1 {
                        if (response.response?.statusCode == 500) {
                            if !self.failedPlaylists.isEmpty {
                                self.generateAlert(title: "Playlists Could Not Be Added", message: self.failedPlaylists.joined(separator: ",") + " are not yet supported." , alertActionTitle: "OK")
                            }
                        }
                        self.performSegue(withIdentifier: "addPlaylistsToMix", sender: self)
                    }
                case .failure(_) :
                    self.failedPlaylists.append(myPlaylist.name)
                }
            }
            if failedPlaylists.count > 0 {
                self.generateAlert(title: "Playlists Could Not Be Added", message: failedPlaylists.joined(separator: ","), alertActionTitle: "OK")
            }
        }
    }
    
    func findPlaylist(playlistName: String) -> Playlist {
        for playlist in playlists {
            if playlist.name == playlistName {
                return playlist
            }
        }
        return Playlist(id: "", imageURL: "", name: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue back to mix")
        if segue.identifier == "addPlaylistsToMix" {
            print("go back to mix")
            if let dest = segue.destination as? MixVC {
                dest.spaceID = partyID
            }
        }
    }
        
     func generateAlert(title: String, message: String, alertActionTitle: String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: alertActionTitle, style: .default))
           
           self.present(alertController, animated: true, completion: nil)
       }
    
    func createSpinnerView() {
        let child = SpinnerViewController()
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

