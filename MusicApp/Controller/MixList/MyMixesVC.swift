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
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var MixesTableView: UITableView!
    
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLogic()
        UserDefaults.standard.set([String](), forKey: "spaces")
        
            AF.request("https://us-central1-streamline-5ab87.cloudfunctions.net/helloworld")

        // Do any additional setup after loading the view.
    }
    
    func setUpLogic() {
        MixesTableView.delegate = self
        MixesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("running view did appear")
        spaceIDs = UserDefaults.standard.array(forKey: "spaces") as! [String]
        print("space ids lenght: ", spaceIDs.count)
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
        return mixes.count
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedMix = mixes[indexPath.row]
//        performSegue(withIdentifier: "to", sender: self)
//    }
}
