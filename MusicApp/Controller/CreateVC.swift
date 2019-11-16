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
        let parameters = ["id": SpaceID.text]
        guard let url = URL(string: "https://us-central1-streamline-5ab87.cloudfunctions.net/new_party") else {
            return
        }
        AF.request(url, method: .post, parameters: parameters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
