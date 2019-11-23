//
//  AppDelegate.swift
//  MusicApp
//
//  Created by shaina on 11/2/19.
//  Copyright © 2019 shaina. All rights reserved.
//

/*
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    
    let SpotifyClientID = "2fd46a7902e043e4bcb8ccda3d1381b2"
    let SpotifyRedirectURL = URL(string: "cosmix-app-login://callback")!
    var playURI = ""
    var accessToken: String!
    
    //SPOTIFY PLAYER MANAGEMENT
       func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
         print("connected")
           
           self.appRemote.playerAPI?.delegate = self
           self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
             if let error = error {
               debugPrint(error.localizedDescription)
             }
           })
       }
       
       func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
         print("disconnected")
       }
       func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
         print("failed")
       }
       func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
         debugPrint("Track name: %@", playerState.track.name)
       }
       
       
       func connect() {
           print("running connection")
         self.appRemote.authorizeAndPlayURI(self.playURI)
       }
       
       //STOP MUSIC IF USER LEAVES APP
       func applicationWillResignActive(_ application: UIApplication) {
         if self.appRemote.isConnected {
           self.appRemote.disconnect()
         }
       }
       
       //RECONNECT TO APP REMOTE IF USER RE-OPENS APP
       func applicationDidBecomeActive(_ application: UIApplication) {
               if let _ = self.appRemote.connectionParameters.accessToken {
                   self.appRemote.connect()
               }
       }
    
    //advanced authentication
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      print("success", session)
      accessToken = session.accessToken
        appRemote.connectionParameters.accessToken = session.accessToken
        
        appRemote.connect()
        print("pausing song")
        print("app remote player api", appRemote.playerAPI.debugDescription)
        appRemote.playerAPI?.pause(nil)

    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      print("renewed", session)
    }
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
        configuration.tokenSwapURL =  URL(string: "https://cosmix-app.herokuapp.com/api/token")
        configuration.tokenRefreshURL =  URL(string: "https://cosmix-app.herokuapp.com/api/refresh_token")
        configuration.playURI = "spotify:track:20I6sIOMTCkB6w7ryavxtO"
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
      return manager
    }()
    
          lazy var appRemote: SPTAppRemote = {
            let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
    //        appRemote.connectionParameters.accessToken = self.accessToken
            appRemote.delegate = self
            return appRemote
          }()
    
    
    //basic authentication
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      let parameters = appRemote.authorizationParameters(from: url);

            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                self.accessToken = access_token
                print("access token", self.accessToken)
            } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
                // Show the error
            }
      return true
    }
 */
   
    /*
    func connect() {
      self.appRemote.authorizeAndPlayURI(self.playURI)
    }
    
    
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      debugPrint("Track name: %@", playerState.track.name)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      if self.appRemote.isConnected {
        self.appRemote.disconnect()
      }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
      if let _ = self.appRemote.connectionParameters.accessToken {
        self.appRemote.connect()
      }
    }

    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
          if let error = error {
            debugPrint(error.localizedDescription)
          }
        })
    }
    
    lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self as! SPTAppRemoteDelegate
      return appRemote
    }()
    
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("failed")

    }
    
    */

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //spotify advanced authentication
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        return true
    }
    //spotify advanced authentication
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("running the token setting")
    
        self.sessionManager.application(app, open: url, options: options)
        print("line after session manager")
      return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}
*/

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var rootViewController = ConnectSpotifyViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        rootViewController.sessionManager.application(app, open: url, options: options)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if (rootViewController.appRemote.isConnected) {
            rootViewController.appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
            rootViewController.appRemote.connect()
        }
    }
}



