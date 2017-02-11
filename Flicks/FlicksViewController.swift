//
//  FlicksViewController.swift
//  Flicks
//
//  Created by Arnav Jain on 1/31/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endPoint = "now_playing"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavBar color, matched to icon color
        navigationController?.navigationBar.barTintColor = UIColor(red:244/255, green: 170/255 , blue: 66/255, alpha: 1)
        //NavBar title color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    self.tableView.reloadData()
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
            }
        }
        task.resume()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlicksCell", for: indexPath) as! MovieCell
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as? String
        let overview = movie?["overview"] as? String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        if let posterPath = movie?["poster_path"] as? String {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseURL + posterPath)
        cell.posterView?.setImageWith(imageUrl! as URL)
            
        }
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                }
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            }
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        
            task.resume()
            
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = self.movies?[(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
    }
 

}
