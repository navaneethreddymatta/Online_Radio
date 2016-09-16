//
//  PlayerViewController.swift
//  HW02
//
//  Created by student on 7/23/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import Jukebox

class PlayerViewController: UIViewController, JukeboxDelegate, UITableViewDataSource, UITableViewDelegate {
    var isNew = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Player"
        if AppDelegate.tracksList.count == 1 {
            AppDelegate.jukeBox?.stop()
            let jItem = JukeboxItem(URL: NSURL(string: AppDelegate.tracksList[0].url)!)
            AppDelegate.tracksList[0].jukeBoxItem = jItem
            AppDelegate.jukeBox = Jukebox(delegate: self, items: [ jItem ] )
            AppDelegate.currentTrack = AppDelegate.tracksList[0]
            AppDelegate.jukeBox?.play()
            updatePlayerDisplay()
        } else {
            if AppDelegate.currentTrack != nil {
                updatePlayerDisplay()
            }
            print("Total items in list - \(AppDelegate.tracksList.count)")
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    @IBOutlet weak var trackTitle: UILabel!
    
    @IBAction func playPreviousTrack(sender: AnyObject) {
        AppDelegate.jukeBox?.playPrevious()
        var ind = 0
        for task in AppDelegate.tracksList {
            if task.url == AppDelegate.currentTrack!.url {
                break
            }
            ind += 1
        }
        if ind > 0 {
            ind -= 1
            AppDelegate.currentTrack = AppDelegate.tracksList[ind]
            updatePlayerDisplay()
        }
    }
    
    @IBOutlet weak var playToggleLabel: UIButton!
    
    @IBOutlet weak var trackImage: UIImageView!
    
    @IBAction func playToggle(sender: AnyObject) {
        if AppDelegate.jukeBox?.state == .Playing {
            AppDelegate.jukeBox?.pause()
        } else {
            AppDelegate.jukeBox?.play()
        }
    }
    @IBAction func playNextTrack(sender: AnyObject) {
        AppDelegate.jukeBox?.playNext()
        var ind = 0
        for task in AppDelegate.tracksList {
            if task.url == AppDelegate.currentTrack!.url {
                break
            }
            ind += 1
        }
        if ind < AppDelegate.tracksList.count - 1 {
            ind += 1
            AppDelegate.currentTrack = AppDelegate.tracksList[ind]
            updatePlayerDisplay()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return AppDelegate.tracksList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playListRow", forIndexPath: indexPath)
        // Configure the cell...
        /*if let appCell = cell as? PlayListTableViewCell {
            appCell.track = AppDelegate.tracksList[indexPath.row]
        }*/
        
        cell.textLabel?.text = AppDelegate.tracksList[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
           // print(indexPath.row)
            
            //let NSTrackURl = NSURL(fileURLWithPath: AppDelegate.tracksList[indexPath.row].url)
            //AppDelegate.jukeBox?.removeItems(withURL: NSTrackURl)
            let jbItem = AppDelegate.tracksList[indexPath.row].jukeBoxItem
            AppDelegate.jukeBox?.remove(item: jbItem!)
            AppDelegate.tracksList.removeAtIndex(indexPath.row)
            playlistTableView.reloadData()
        }
    }

    
    func jukeboxStateDidChange(state : Jukebox) {
    }
    func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
    }
    func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
    }
    func jukeboxDidUpdateMetadata(jukebox : Jukebox, forItem: JukeboxItem){
    }
    
    func updatePlayerDisplay() {
        let track = AppDelegate.currentTrack
        let trackTitleStr = track!.title
        let displayImageURL = track!.image
        trackTitle.text = trackTitleStr
        let NSImageURL = NSURL(string: displayImageURL)
        if let imageData = NSData(contentsOfURL: NSImageURL!) {
            trackImage?.image = UIImage(data: imageData)
        }
    }
}
