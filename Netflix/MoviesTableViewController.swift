
import UIKit
import Cosmos
import SDWebImage
import Alamofire
import Reachability
import CoreData

class MoviesTableViewController: UITableViewController  {
    
    let reachability = try! Reachability()
    var Tablejson : [Dictionary<String, Any>]?
    var coreDataTable : [Dictionary<String, Any>]?
    
    func getJson() -> Void
    
    {
        print("get api ")
        let url = URL(string: "https://api.androidhive.info/json/movies.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            do{
                let x = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [Dictionary<String, Any>]
                self.Tablejson = x
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                    self.moveToCoreData()
                }
            }catch
            {
                print("error")
            }
         }
             task.resume()
    }
//    func alamoFireMethod()-> Void
//    {
//        Alamofire.request("https://api.androidhive.info/json/movies.json").validate()
//            .responseJSON { (response) in
//                if let error = response.error
//                {
//                    print("Error")
//
//                }else if let jsonArray = response.result.value as? [[Dictionary<String,Any>]]
//                {
//                    print("Success array")
//                }else if let jsonDict = response.result.value as? [Dictionary<String,Any>]
//                {
//                    print("Success")
//                    self.Tablejson = jsonDict
//                    self.tableView.reloadData()
//                }
//
//            }
//    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         reachability.whenReachable = {  reachability in
             if reachability.connection == .wifi{
                 self.clearMyCoreData()
                 self.getJson()
                 print("Reachable via WiFi")
             } else
             {
                 print("Reachable via Cellular")
             }
         }
         reachability.whenUnreachable = { _ in
             print("Not reachable")
             self.getFromCoreData()
         }

         do {
             try reachability.startNotifier()
         } catch {
             print("Unable to start notifier")
         }
    }
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.tableView.reloadData()
        self.navigationItem.title = "Movies"
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Tablejson?.count != nil
        {   return Tablejson?.count ?? 15
        }else
        {
            return 0
        }
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if Tablejson != nil
        {
        let movieRate = cell.contentView.viewWithTag(3) as! CosmosView
        let movieName = cell.contentView.viewWithTag(2) as! UILabel
        movieName.text = Tablejson![indexPath.row]["title"] as! String
        let movieImage = cell.contentView.viewWithTag(1) as! UIImageView
        movieImage.sd_setImage(with: URL(string: Tablejson![indexPath.row]["image"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
        if  Tablejson![indexPath.row]["rating"] as? Double != nil
        {
            movieRate.rating = (Tablejson![indexPath.row]["rating"] as! Double)/3
            movieRate.settings.updateOnTouch = false
        }else
        {
            movieRate.rating = 1.2
            movieRate.settings.updateOnTouch = false
        }
            
        }
        return cell
       
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! ViewController
        obj.movName =  (Tablejson![indexPath.row]["title"] as? String)!
        obj.movRate = Tablejson![indexPath.row]["rating"] as? Double
        obj.movYear = (Tablejson![indexPath.row]["releaseYear"]) as! Int
        obj.movgen = (Tablejson![indexPath.row]["genre"] as? [String])!
        obj.movImage = (Tablejson![indexPath.row]["image"] as? String)!
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToCoreData() -> Void
    {
        print("Data Moved To Core Data")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)

        for i in 0..<Tablejson!.count {
        
        let movie = NSManagedObject(entity: entity!, insertInto: context)
        movie.setValue(self.Tablejson![i]["title"] as! String, forKey: "title")
        movie.setValue(self.Tablejson![i]["image"]  as! String, forKey: "image")
        movie.setValue(self.Tablejson![i]["rating"] as! Double, forKey: "rating")
        movie.setValue(self.Tablejson![i]["releaseYear"] as! Int, forKey: "releaseYear")
        }
        try? context.save()
       
    }
    func clearMyCoreData() -> Void
    {
        print("CoreData is Cleared")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Movie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try appDelegate.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            // TODO: handle the error
        }
    }
     func getFromCoreData() -> Void
    {
        print("Get From Core Data OFFLine ")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            do
            {
                let results = try context.fetch(request)
                if !results.isEmpty {
                    print(results.count)
                    for i in 0..<15
                    {
                        guard let title = results[i].value(forKey: "title")! as? String else {return}
                        guard let image =  results[i].value(forKey: "image") as? String else {return}
                        guard let  rating  = results[i].value(forKey: "rating") as? Double else {return}
                        guard let  year  = results[i].value(forKey: "releaseYear")as? Int else {return}

                        self.Tablejson?[i].updateValue(title as Any, forKey: "title")
                        self.Tablejson?[i]["image"] = [image]
                        self.Tablejson?[i]["rating"] = [rating]
                        self.Tablejson?[i]["releaseYear"] = [year]
                    
                        print(self.Tablejson?[i]["title"])
                    }
                    
                }
            } catch let error as NSError
        {
                print(error)
            }
    
       
        
    }

}
