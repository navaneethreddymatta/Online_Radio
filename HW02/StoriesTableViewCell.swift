//
//  StoriesTableViewCell.swift
//  HW02
//
//  Created by student on 7/22/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import Jukebox

class StoriesTableViewCell: UITableViewCell, JukeboxDelegate {
    var tableViewObj:UITableView?
    var story:JSON? {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var StoryTitleField: UILabel!
    
    @IBOutlet weak var storyPublishedDateField: UILabel!
    
    @IBOutlet weak var storyImage: UIImageView!
    
    @IBAction func addToPlaylist(sender: UIButton) {
        var indexPath: NSIndexPath!
        var indexPathRow = 0
        if let superview = sender.superview {
            if let cell = superview.superview as? StoriesTableViewCell {
                indexPath = self.tableViewObj!.indexPathForCell(cell)
                indexPathRow = indexPath.row
            }
        }
        let url = String(story!["audio"][0]["format"]["mp3"][0]["$text"])
        let jbItem = JukeboxItem(URL: NSURL(string: url)!)
        
        let trackTitle = String((story?["title"]["$text"])!)
        var imageURL:String? = "https://upload.wikimedia.org/wikipedia/commons/b/b8/NicePlayer.png"
        let imageJSON = String((story?["thumbnail"]["medium"]["$text"])!)
        if imageJSON != "null" {
            imageURL = imageJSON
        }
        let track = Track(url:url, title:trackTitle, image:imageURL!)
        track.jukeBoxItem = jbItem
        if AppDelegate.jukeBox == nil {
            AppDelegate.jukeBox = Jukebox(delegate: self, items: [ ] )
            AppDelegate.currentTrack = track
        }
        AppDelegate.tracksList.append(track)
        AppDelegate.jukeBox?.append(item: jbItem, loadingAssets: true)
    }
    
    private func updateUI() {
        StoryTitleField.text = String((story?["title"]["$text"])!)
        storyPublishedDateField.text = String((story?["storyDate"]["$text"])!)
        var imageURL:String? = "https://upload.wikimedia.org/wikipedia/commons/b/b8/NicePlayer.png"
        let imageJSON = String((story?["thumbnail"]["medium"]["$text"])!)
        if imageJSON != "null" {
            imageURL = imageJSON
        }
        /*let NSImageURL:NSURL? = NSURL(string: imageURL!)
        if let url = NSImageURL {
            imageView?.sd_setImageWithURL(url)
        }*/
        let NSImageURL = NSURL(string: imageURL!)
        if let imageData = NSData(contentsOfURL: NSImageURL!) {
            storyImage?.image = UIImage(data: imageData)
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
}
