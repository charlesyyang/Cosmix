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

class MixVC: UIViewController, UITableViewDelegate{
    
    var mix = [Song]()
    var selectedSong = Song?.self
    var spaceID: String!
    @IBOutlet weak var MixesTableView: UITableView!
    
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFilteredSongs()
        // Do any additional setup after loading the view.
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
                print("running this")
                if let JSON = value as? NSArray {
                    print("artisto", JSON[0])
                    
                    print("running this 2")
//                    let idsuccess = JSON["result"] as! Bool
 //                   if idsuccess {
 //                       print("successsss!!!!")
 //                   } else {
 //                   }
                }
 //
            case .failure(let error):
                break
        }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mix.count
    }
    
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MixTableViewCell {
            let song = mix[indexPath.row]
//            cell.mixID.text = song.id
//            cell.mixName.text = mix.name
            return cell
        }
        
        return UITableViewCell()
    }
        
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        selectedMix = mixes[indexPath.row]
    //        performSegue(withIdentifier: "to", sender: self)
    //    }
}
    

