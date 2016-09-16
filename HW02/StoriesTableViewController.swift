//
//  StoriesTableViewController.swift
//  HW02
//
//  Created by student on 7/22/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class StoriesTableViewController: UITableViewController {
    var programId:String?
    var dataFeedObjects:JSON?
    var tabTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tabTitle
        fetchData()
    }
    
    private func fetchData() {
        let url = "http://api.npr.org/query?id=\(programId!)&dateType=story&output=JSON&apiKey=MDI1NDQ5MjI3MDE0NjkyMzM1NTIwZGZjMg000"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonData = JSON(value)
                    self.dataFeedObjects = jsonData["list"]["story"]
                    self.tableView.reloadData()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.dataFeedObjects == nil {
            return 0
        } else {
            return (self.dataFeedObjects?.count)!
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("storyCellIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        if let appCell = cell as? StoriesTableViewCell {
            appCell.story = dataFeedObjects![indexPath.row]
            appCell.tableViewObj = self.tableView
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playerVC = segue.destinationViewController as? PlayerViewController
        playerVC?.isNew = false
        if segue.identifier == "playTrack" {
            var indexPath: NSIndexPath!
            var indexPathRow = 0
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? StoriesTableViewCell {
                        indexPath = tableView.indexPathForCell(cell)
                        indexPathRow = indexPath.row
                    }
                }
            }
            playerVC?.isNew = true
            let dataObj = dataFeedObjects![indexPathRow]
            let url = String(dataObj["audio"][0]["format"]["mp3"][0]["$text"])
            let title = String(dataObj["title"]["$text"])
            var imageURL:String? = "https://upload.wikimedia.org/wikipedia/commons/b/b8/NicePlayer.png"
            let imageJSON = String((dataObj["thumbnail"]["medium"]["$text"]))
            if imageJSON != "null" {
                imageURL = imageJSON
            }
            AppDelegate.tracksList.removeAll()
            let track = Track(url:url, title:title, image:imageURL!)
            AppDelegate.tracksList.append(track)
        }
    }
}
