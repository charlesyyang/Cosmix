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

class MixVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate{
    
    var mix = [Song]()
    var selectedSong: Song!
    var spaceID: String!
    var spotifyToken: String!
    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var MixesTableView: UITableView!
    
    @IBOutlet weak var SpaceIDLabel: UILabel!
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    @IBOutlet weak var connectToSpotifyButton: UIButton!

    @IBOutlet weak var CurrentSongLabel: UILabel!
    
    @IBOutlet weak var CurrentSongArtist: UILabel!
    
    @IBOutlet weak var CurrentSongImage: UIImageView!
    
      fileprivate let SpotifyClientID = "2fd46a7902e043e4bcb8ccda3d1381b2"
        fileprivate let SpotifyRedirectURI = URL(string: "cosmix-app-login://callback")!
        
        lazy var configuration: SPTConfiguration = {
            let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
            configuration.playURI = ""
            configuration.tokenSwapURL = URL(string: "https://cosmix-app.herokuapp.com/api/token")
            configuration.tokenRefreshURL = URL(string: "https://cosmix-app.herokuapp.com/api/refresh_token")
            return configuration
        }()

        lazy var sessionManager: SPTSessionManager = {
               let manager = SPTSessionManager(configuration: configuration, delegate: self)
               return manager
           }()

           lazy var appRemote: SPTAppRemote = {
               let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
               appRemote.delegate = self
               return appRemote
           }()

          var lastPlayerState: SPTAppRemotePlayerState?
        
           func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
             presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
         }

         func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
             presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
         }

         func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
             appRemote.connectionParameters.accessToken = session.accessToken
            self.spotifyToken = session.accessToken
            UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
            print("spotify token", spotifyToken)
             appRemote.connect()
         }

         // MARK: - SPTAppRemoteDelegate

         func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
     //        appRemote.playerAPI?.pause(nil)
             appRemote.playerAPI?.delegate = self

             appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
                 if let error = error {
                     print("Error subscribing to player state:" + error.localizedDescription)
                 }
             })
             fetchPlayerState()
            pausePlayMusic()
    //        updateViewBasedOnConnected()

            print("dismissing vc")
         }
        

         
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             print("preparing for segue")
             if segue.identifier == "addPlaylists" {
                 print("go to add playlist")
                 if let dest = segue.destination as? AddPlaylistsViewController {
                     dest.partyID = spaceID
                    spotifyToken = UserDefaults.standard.string(forKey: "accessToken")
                    print("spotify token in prepare", spotifyToken)
                    dest.spotifyToken = spotifyToken
                 }
             }
            if segue.identifier == "loginSpotify" {
                print("go to login")
                if let dest = segue.destination as? ViewController {
                    dest.partyID = spaceID
                }
            }
         }

        override func viewDidLoad() {
            super.viewDidLoad()
           MixesTableView.delegate = self
           MixesTableView.dataSource = self
           setUpLogic()
           getFilteredSongs()
            print("calling view did load")
            print("app remote connected", appRemote.isConnected)

            //only apply the blur if the user hasn't disabled transparency effects
            if !UIAccessibility.isReduceTransparencyEnabled {
//                view.backgroundColor = .clear

                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.tag = 100

                view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
                view.addSubview(connectToSpotifyButton)
            } else {
                view.backgroundColor = .white
            }
        
            // Do any additional setup after loading the view.
        }
        
        override func viewDidAppear(_ animated: Bool) {
            MixesTableView.reloadData()
            updateViewBasedOnConnected()
        }
        
         func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
            updateViewBasedOnConnected()
            print("fail connection")
             lastPlayerState = nil
         }

         func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
            updateViewBasedOnConnected()
            print("fail connection")
             lastPlayerState = nil
         }

          func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
            update(playerState: playerState)
        }
        
        func updateViewBasedOnConnected() {
               if (appRemote.isConnected) {
     //           connectToSpotifyButton.titleLabel?.text = "test"
   //         self.connectToSpotifyButton.isHidden = true
               } else {
//               self.connectToSpotifyButton.isHidden = false
               }
           }
        
        @IBAction func pausePlayPressed(_ sender: Any) {
       //     self.dismiss(animated: true, completion: nil)
    //        self.performSegue(withIdentifier: "toAddPlaylists", sender: self)
            print("pause / play")
            fetchPlayerState()
            pausePlayMusic()
        
    //        appRemote.playerAPI?.pause(nil)
            print("last player state: ", self.lastPlayerState?.contextTitle)

    //        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
    //            print("resuming")
    //            appRemote.playerAPI?.resume(nil)
    //        } else {
    //            print("pausing")
    //            appRemote.playerAPI?.pause(nil)
    //        }
        }
        
        func pausePlayMusic() {
            print("player state,", lastPlayerState)
            if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
                appRemote.playerAPI?.resume(nil)
            } else {
                appRemote.playerAPI?.pause(nil)
            }
        }
        @IBAction func connectToSpotifyPressed(_ sender: UIButton) {
            let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
            sender.isHidden = true
            removeSubview()
            if #available(iOS 11, *) {
                     // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
                     sessionManager.initiateSession(with: scope, options: .clientOnly)
                 } else {
                     // Use this on iOS versions < 11 to use SFSafariViewController
                     sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
                 }
        }
        

        func removeSubview(){
            print("Start remove sibview")
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
                print("No!")
            }
        }
        
        func update(playerState: SPTAppRemotePlayerState) {
            if lastPlayerState?.track.uri != playerState.track.uri {
                fetchArtwork(for: playerState.track)
            }
            lastPlayerState = playerState
            print("updated last player state: ", lastPlayerState?.contextTitle)
            print("updating state: ", lastPlayerState?.isPaused)
            if playerState.isPaused {
     //        puaseAndPlayButton.setImage(UIImage(named: "play"), for: .normal)
            } else {
    //            puaseAndPlayButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
        
        func fetchArtwork(for track:SPTAppRemoteTrack) {
            appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
                if let error = error {
                    print("Error fetching track image: " + error.localizedDescription)
                } else if let image = image as? UIImage {
       //             self?.imageView.image = image
                }
            })
        }

        func fetchPlayerState() {
            appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
                if let error = error {
                    print("Error getting player state:" + error.localizedDescription)
                } else if let playerState = playerState as? SPTAppRemotePlayerState {
                    print("player state: ", playerState.contextTitle)
                    self?.update(playerState: playerState)
                }
            })
        }
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        fileprivate func presentAlertController(title: String, message: String, buttonTitle: String) {
              let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
              let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
              controller.addAction(action)
              present(controller, animated: true)
          }
    
    @IBAction func addToSpotifyPressed(_ sender: Any) {
        let parameters = ["id": spaceID, "name": spaceID + "-cosmix", "token": spotifyToken]
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/save") else {
            return
        }
         //Alamofire request to check party ID
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
        debugPrint(response)
            switch response.result {
            case .success(_) :
                print("added playlist to party:")
            case .failure(_) :
                print("failed add to spotify")
            }
        }
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
        print("space id is: ", spaceID)
        if !spaceIDList.contains(spaceID) {
            spaceIDList.append(spaceID)
            UserDefaults.standard.set(spaceIDList, forKey: "spaces")
        }
//        spotifyToken = delegate.accessToken
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
    
    @IBAction func addMusicPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "addPlaylists", sender: self)
    }
}
    

