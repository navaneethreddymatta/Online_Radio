//
//  ProgramsTableViewController.swift
//  HW02
//
//  Created by student on 7/22/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class ProgramsTableViewController: UITableViewController {
    var dataFeedObjects:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
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
    
    private func fetchData() {
        Alamofire.request(.GET, "http://api.npr.org/list?id=3004&output=JSON").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonData = JSON(value)
                    self.dataFeedObjects = jsonData["item"]
                    //print(self.dataFeedObjects)
                    self.tableView.reloadData()
                    
                   self.tableView.estimatedRowHeight = self.tableView.rowHeight
                   self.tableView.rowHeight = UITableViewAutomaticDimension
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("programIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        //cell.textLabel?.text = String(self.dataFeedObjects![indexPath.row]["title"]["$text"])
        //cell.detailTextLabel?.text = String(self.dataFeedObjects![indexPath.row]["additionalInfo"]["$text"])
        if let appCell = cell as? ProgramsTableViewCell {
            appCell.story = dataFeedObjects![indexPath.row]
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        if let storyVC = segue.destinationViewController as? StoriesTableViewController {
            let currentProgramID = String(self.dataFeedObjects![indexPath.row]["id"])
            storyVC.programId = currentProgramID
            storyVC.tabTitle = String(self.dataFeedObjects![indexPath.row]["title"]["$text"])
        }
    }
}
