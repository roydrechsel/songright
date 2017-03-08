//
//  Recordings.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/7/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit

class Recordings: Equatable {
    
    var title: String?
    var timestamp: Date
    var length: Double
    
    init(title: String?, timestamp: Date = Date(), length: Double) {
        
        self.title = title
        self.timestamp = timestamp
        self.length = length
    }
}


func ==(lhs: Recordings, rhs: Recordings) -> Bool {
    
    return lhs.title == rhs.title && lhs.timestamp == rhs.timestamp && lhs.length == rhs.length
}
