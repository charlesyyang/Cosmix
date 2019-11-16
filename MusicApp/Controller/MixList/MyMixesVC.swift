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

class MyMixesVC: UIViewController, UITableViewDelegate{
    var mixes = [Mix]()
    var selectedMix = Mix?.self
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var MixesTableView: UITableView!
    
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/helloworld") else {
            return
        }
        
        Alamofire.request(url,
                          method: .get,
                          parameters: [])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error")
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        return
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MyMixTableViewCell {
            let mix = mixes[indexPath.row]
            cell.mixID.text = mix.id
            cell.mixName.text = mix.name
            return cell
        }
        
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedMix = mixes[indexPath.row]
//        performSegue(withIdentifier: "to", sender: self)
//    }
}
