//
//  Track.swift
//  HW02
//
//  Created by student on 7/23/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import Foundation
import Jukebox

class Track {
    var url:String = ""
    var title:String = ""
    var image:String = ""
    var jukeBoxItem:JukeboxItem?
    
    init(url: String, title: String, image: String) {
        self.url = url
        self.title = title
        self.image = image
    }
}