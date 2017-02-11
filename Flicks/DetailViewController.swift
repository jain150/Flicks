//
//  DetailViewController.swift
//  Flicks
//
//  Created by Arnav Jain on 2/10/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!

    @IBOutlet weak var overviewLable: UILabel!
    
    var movie: NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        titleLable.text = title
        
        let overview = movie["overview"] as? String
        overviewLable.text = overview
        
        if let posterPath = movie?["poster_path"] as? String {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseURL + posterPath)
            posterImageView?.setImageWith(imageUrl! as URL)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */
    

}
