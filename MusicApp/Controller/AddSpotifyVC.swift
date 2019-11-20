//
//  AddSpotifyVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/19/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit

class AddSpotifyVC: UIViewController {

    
    let SpotifyClientID = "2fd46a7902e043e4bcb8ccda3d1381b2"
    let SpotifyRedirectURI = URL(string: "http://com.example.streamline/callback")!
    
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURI
    )
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      let parameters = appRemote.authorizationParameters(from: url);
//
//            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
//                appRemote.connectionParameters.accessToken = access_token
//                self.accessToken = access_token
//            } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
//                // Show the error
//            }
//      return true
//    }
}
