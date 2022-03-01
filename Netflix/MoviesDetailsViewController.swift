//
//  MoviesDetailsViewController.swift
//  Netflix
//
//  Created by Ahmed Mostafa on 07/02/2022.
//

import UIKit
import Cosmos
class MoviesDetailsViewController: UIViewController , UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var wallpaperImg: UIImageView!
    @IBOutlet weak var movieRate: CosmosView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    var movieName:String?
    var movieGenre : [String]?
    var movieRating : Double?
    var movieImg : String?
    var movRealseYear : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movieName!
        movieRate.rating = (movieRating!)/2 ?? 1
        movieRate.settings.updateOnTouch = false
        let url = URL(string: movieImg!)
        movieImage.kf.setImage(with: url)
        movieImage.layer.borderWidth = 1
        movieImage.layer.masksToBounds = false
        movieImage.layer.borderColor = UIColor.black.cgColor
        movieImage.layer.cornerRadius = movieImage.frame.height / 2
        movieImage.clipsToBounds = true
        wallpaperImg.kf.setImage(with: url)
        self.blurEffect()
        movieYear.text = "\(movRealseYear!)"
    }
    var context = CIContext(options: nil)

    func blurEffect() {

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: wallpaperImg.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(25, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        wallpaperImg.image = processedImage
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieGenre?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesGenresTableViewCell
        cell.genreLabel.text = movieGenre![indexPath.row]
    
    return cell
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
