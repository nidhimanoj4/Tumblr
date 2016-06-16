//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Nidhi Manoj on 6/16/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [NSDictionary] = []
    @IBOutlet weak var photosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosTableView.delegate = self
        photosTableView.dataSource = self
        photosTableView.rowHeight = 240;
        
        
        let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                    
                    self.photosTableView.reloadData()
                }
            }
        });
        task.resume()
    }
    
    
    
    //Add the extra functions in the protocol (abstract classes) that we added at the top
    //This describes teh number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //This describes how to configure the cells
    //given an index, get the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell

        let post = posts[indexPath.row] //let the single post we want for this cell to be the element in posts array at theis row's index
        //POST is a dictionary because posts was an array of NSDictionary
        //get the photos array of the post at the key "photos"
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            //set the imageView with setImageWithURL from the AFNetwroking pod to be this first element - which is a picture
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            if let imageUrl = NSURL(string: imageUrlString!) {
                // NSURL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                cell.photoImageView.setImageWithURL(imageUrl)
            } else {
                // NSURL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }

        
        return cell
    }
    
    
    
    // Do any additional setup after loading the view.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoDetailsViewController
        var indexOfCell = photosTableView.indexPathForCell(sender as UITableViewCell)
        
        //Get the original image url
        let originalPostCell = (posts[indexOfCell]) as! NSDictionary
        let photosDict = originalPostCell["photos"] as! NSDictionary
        let originalSizeDict = photosDict["orginal_size"] as
        
        //destinationViewController.image = self.OriginalImageView.image
        
    }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
