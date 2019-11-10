//
//  MyMixesVC.swift
//  MusicApp
//
//  Created by Charles Yang on 11/9/19.
//  Copyright © 2019 shaina. All rights reserved.
//

import UIKit

class MyMixesVC: UIViewController, UITableViewDelegate{

    var mixes = [Mix]()
    
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mixTableCell") as? MyMixTableViewCell {
            let mix = Mix[indexPath.row]
            let data = try? Data(contentsOf: myURL)
            cell.pokemonName.text = Pokemon.name
            cell.pokemonNumber.text = String(Pokemon.number)
            return cell
        }
        
        return UITableViewCell()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
