//
//  MoviesCollectionViewController.swift
//  Netflix
//
//  Created by Ahmed Mostafa on 07/02/2022.
//

import UIKit
import Kingfisher


class MoviesCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout  {
    
    var Tablejson : [Dictionary<String, Any>]?
        @objc func getJson() -> Void
        {
        let url = URL(string: "https://api.androidhive.info/json/movies.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            do{
                self.Tablejson = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [Dictionary<String, Any>]
//                self.Tablejson = json
//                print(json[1] , self.value(forKey: "title") as Any)
            }catch
            {
                print("error")
            }
         }
             task.resume()
            DispatchQueue.main.async
            {
                self.collectionView.reloadData()
            }
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getJson()
        self.collectionView.reloadData()
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Movies"
        self.getJson()
        self.collectionView.reloadData()
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Tablejson?.count ?? 15
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MoviesCollectionViewCell
        if Tablejson != nil
        {
        
        cell.movieName.text = Tablejson![indexPath.row]["title"] as? String 
        let url = URL(string: Tablejson![indexPath.row]["image"] as! String)
        cell.movieImg.kf.setImage(with: url)
//        cell.movieImg.image = UIImage(named: "savingPrivateRayn")
        // Configure the cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: (UIScreen.main.bounds.width)/2.51234, height: (UIScreen.main.bounds.height)/4.9)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10 , left: 40, bottom: 0, right: 25)
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "movDataVC") as! MoviesDetailsViewController
        obj.movieName = Tablejson![indexPath.row]["title"] as? String
        obj.movieRating = Tablejson![indexPath.row]["rating"] as? Double
        obj.movieGenre = Tablejson![indexPath.row]["genre"] as? [String]
        obj.movRealseYear = Tablejson![indexPath.row]["releaseYear"] as? Int
        obj.movieImg = Tablejson![indexPath.row]["image"] as? String
        print("herrreeeeee")
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


