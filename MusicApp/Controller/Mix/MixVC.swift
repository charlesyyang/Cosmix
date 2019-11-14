//
//  MixVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/11/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import Foundation
import UIKit

class MixVC: UIViewController, UITableViewDelegate{
    
    var mixes = [Mix]()
    var selectedMix = Mix?.self
    
    @IBOutlet weak var MixesTableView: UITableView!
    
    
    @IBOutlet weak var AddMixButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixes.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MixTableViewCell {
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
    

