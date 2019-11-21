//
//  MyMixesVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/9/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MyMixesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var mixes = [Mix]()
    var spaceIDs = [String]()
    var selectedMix = Mix?.self
    var selectedID: String = ""
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var MixesTableView: UITableView!
    
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLogic()
        if (UserDefaults.standard.array(forKey: "spaces") != nil) {
            spaceIDs = UserDefaults.standard.array(forKey: "spaces") as! [String]
        }
        AF.request("https://us-central1-streamline-5ab87.cloudfunctions.net/helloworld")

        // Do any additional setup after loading the view.
    }
    
    func setUpLogic() {
        MixesTableView.delegate = self
        MixesTableView.dataSource = self
        if (UserDefaults.standard.array(forKey: "spaces") != nil) {
            spaceIDs = UserDefaults.standard.array(forKey: "spaces") as! [String]
        }
        MixesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.array(forKey: "spaces") != nil) {
            spaceIDs = UserDefaults.standard.array(forKey: "spaces") as! [String]
        }
        MixesTableView.reloadData()
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/get_facts") else {
            return
        }
        var param = ["isrc": "CH3131340084"]
        
        AF.request(url, parameters: param).validate().responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let value) :
                if let JSON = value as? [String: Any] {
                    let artist = JSON["artist"] as! String
                    print(artist)
                    let name = JSON["name"] as! String
                    print(name)
                }
                
            case .failure(let error):
                break
            }
            
//            if let JSON = response.result.get() {
//                print("JSON: \(JSON)")
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MyMixTableViewCell {
            let space = spaceIDs[indexPath.row]
            cell.mixID.text = space
            cell.mixName.text = space
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = spaceIDs[indexPath.row]
        performSegue(withIdentifier: "existingPartyToMixVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        if segue.identifier == "existingPartyToMixVC" {
            print("go to mix from main page")
            if let dest = segue.destination as? MixVC {
                print("set space id tp:", selectedID)
                dest.spaceID = selectedID
            }
        }
    }
    
}
