//
//  JoinVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/16/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class JoinVC: UIViewController {
    
    
    @IBOutlet weak var SpaceID: UITextField!
    
    
    @IBOutlet weak var SpacePassword: UITextField!
    
    @IBOutlet weak var JoinButton: UIButton!
    
    
    @IBAction func JoinButtonPressed(_ sender: Any) {
        if SpaceID.text == "" {
            self.generateAlert()
        } else {
            var param = ["id": SpaceID.text!]
            partyExists(param: param)
        }
    }
    
    func generateAlert() {
        let alertController = UIAlertController(title: "Invalid ID", message: "Please enter a valid ID", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        if segue.identifier == "JoinSuccess" {
            print("go to mix")
            if let dest = segue.destination as? MixVC {
                print("set space id tp:", SpaceID.text)
                dest.spaceID = SpaceID.text!
            }
        }
    }
    
    /// Checks if party exists.
    /// If party exists, segues to next page.
    /// Else, generate an alert for user to enter valid party id.
    /// - Parameter param: ["id": party id]
    func partyExists(param: [String: String]) {
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/check_party") else {
                return
            }
            
            AF.request(url, parameters: param).validate().responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let value) :
                
                if let JSON = value as? [String: Any] {
                    let idsuccess = JSON["result"] as! Bool
                    if idsuccess {
                        self.performSegue(withIdentifier: "JoinSuccess", sender: self)
                    } else {
                        self.generateAlert()
                    }
                }
                
            case .failure(let error):
                self.generateAlert()
            }
        }
    }
}
