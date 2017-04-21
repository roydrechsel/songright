//
//  Recordings.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/7/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

//class Recordings: Equatable

extension Recordings {
    
//    var title: String = "Andrew"
//    var timestamp: Date
//    var length: Double
//    var isFavorite: Bool
    
    convenience init(title: String, timestamp: Date, length: Double, isFavorite: Bool, recordingURL: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.title = title
        self.timestamp = timestamp as NSDate?
        self.length = length
        self.isFavorite = isFavorite
        self.recordingURL = recordingURL
    }
    
    var recordingUrlFromDocuments: String? {
        get {
            if let fileUrl = self.recordingURL, let url = NSURL(string: fileUrl), let fileName = url.lastPathComponent
            {
                let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                let absoluteUrlString = documentsDir.appendingPathComponent(fileName)
                
                return absoluteUrlString
                
            }
            
            return nil
        }
    }
    
    var asset: AVAsset? {
        guard let urlString = recordingUrlFromDocuments, let url = URL(string: urlString) else { return nil }
        return AVURLAsset(url: url)
    }
    
    var audioPlayer: AVAudioPlayer? {
        guard let urlString = recordingUrlFromDocuments, let url = URL(string: urlString) else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }
    
}

//
//func ==(lhs: Recordings, rhs: Recordings) -> Bool {
//    
//    return lhs.title == rhs.title && lhs.timestamp == rhs.timestamp && lhs.length == rhs.length && lhs.isFavorite == rhs.isFavorite
//}
