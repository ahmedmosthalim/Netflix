//
//  ViewController.swift
//  Netflix
//
//  Created by Ahmed Mostafa on 02/02/2022.
//

import UIKit
import Kingfisher
import Cosmos

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
     var movName : String = "";
     var movRate : Double?
     var movYear : Int?
     var movImage : String = "";
    var movgen : [String] = [""];




    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        self.navigationItem.title = movName
        super.viewDidLoad()
//        movieImage.image = UIImage (imageLiteralResourceName: movImage)
        let url = URL(string: movImage)
        movieImage.kf.setImage(with: url)
        movieYear.text = "\(movYear!)"
        
        // Do any additional setup after loading the view.
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text  = movgen[indexPath.row]
        return cell
    }

    
}


