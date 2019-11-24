//
//  joinCreateViewController.swift
//  MusicApp
//
//  Created by shaina on 11/23/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import UIKit
import Alamofire

class joinCreateViewController: UIViewController {

    @IBOutlet weak var createTextField: UITextField!
    @IBOutlet weak var joinTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    var mixID: String!
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        joinButton.roundedButton()
        createButton.roundedButton()
    }
    
    @IBAction func touchOutside(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func createTextKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    func setupUI() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "joinCreateBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "joinCreateBackground"), for: .default)
        
    }
    
    @IBAction func joinPressed(_ sender: Any) {
        if joinTextField.text == "" {
            self.generateAlert(title: "No Mix ID Provided", message: "Please provide a valid Mix ID", alertActionTitle: "OK")
        } else {
            let param = ["id": joinTextField.text!]
            mixID = joinTextField.text!
            partyExistsJoin(param: param)
        }
    }
    @IBAction func createPressed(_ sender: Any) {
        //if space ID is empty, generate alert
        if createTextField.text == "" {
            self.generateAlert(title: "No Mix ID Provided", message: "Please enter a Mix ID", alertActionTitle: "OK")
        } else {
            let parameters = ["id": createTextField.text!]
            mixID = createTextField.text!
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
                                   self.performSegue(withIdentifier: "JoinSuccess", sender: self)
                                
                                }
                           }
                        //check party request failed, generate generic error
                       case .failure(let error):
                           self.generateAlert(title: "Space ID Error", message: "Please try another Space ID", alertActionTitle: "OK")
                       }
                   }
        }
    }
    
    func generateAlert(title: String, message: String, alertActionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertActionTitle, style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           print("preparing for segue")
           if segue.identifier == "JoinSuccess" {
               print("go to mix")
               if let dest = segue.destination as? MixVC {
                   print("set space id tp:", mixID)
                   dest.spaceID = mixID
               }
           }
       }
    

    /// Checks if party exists.
       /// If party exists, segues to next page.
       /// Else, generate an alert for user to enter valid party id.
       /// - Parameter param: ["id": party id]
       func partyExistsJoin(param: [String: String]) {
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
                        self.generateAlert(title: "Could Not Join", message: "There was an error trying to join", alertActionTitle: "OK")
                       }
                   }
                   
               case .failure(let error):
                   self.generateAlert(title: "Could Not Join", message: "There was an error trying to join", alertActionTitle: "OK")
                   }
               }
           }
}
