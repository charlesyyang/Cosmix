//
//  CreateVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/16/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class CreateVC: UIViewController {
    @IBOutlet weak var SpaceID: UITextField!
    
    @IBOutlet weak var SpacePassword: UITextField!
    
    @IBAction func CreateSpaceButton(_ sender: Any) {
        //if space ID is empty, generate alert
        if SpaceID.text == "" {
            self.generateAlert(title: "No Space ID Provided", message: "Please enter a Space ID", alertActionTitle: "OK")
        } else {
            let parameters = ["id": SpaceID.text!]
                //check if space ID already exists in database by using check_party()
                   guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/check_party") else {
                           return
                       }
                        //Alamofire request to check party ID
                       AF.request(url, parameters: parameters).validate().responseJSON { response in
                       switch response.result {
                        
                       //Request call successful
                       case .success(let value):
                           if let JSON = value as? [String: Any] {
                               let idsuccess = JSON["result"] as! Bool
                                //if space ID already exists, generate alert
                               if idsuccess {
                                self.generateAlert(title: "Space ID Taken", message: "Please try another Space ID", alertActionTitle: "OK")
                               }
                               //Space ID does not exist, so call new_party() to create a new party and segue to MixVC
                               else {
                                   guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/new_party") else {
                                       return
                                   }
                                   AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
                                       debugPrint(response) }
                                   self.performSegue(withIdentifier: "toMix", sender: self)
                                
                                }
                           }
                        //check party request failed, generate generic error
                       case .failure(let error):
                           self.generateAlert(title: "Space ID Error", message: "Please try another Space ID", alertActionTitle: "OK")
                       }
                   }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func generateAlert(title: String, message: String, alertActionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertActionTitle, style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Checks if party exists.
    /// If party exists, return true.
    /// Else, return false.
    /// - Parameter param: ["id": party id]
    func partyExists(param: [String: String]) -> Bool {
        print("running party exists")
        var partyExists = false
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/check_party") else {
                return false
            }
            
            AF.request(url, parameters: param).validate().responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let value):
                print("running party success")
                if let JSON = value as? [String: Any] {
                    let idsuccess = JSON["result"] as! Bool
                    if idsuccess {
                        partyExists = true
                    } else {
                        partyExists = false
                    }
                }
                
            case .failure(let error):
                partyExists = false
            }
        }
        return partyExists
    }
}
