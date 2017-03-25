//
//  RecordingsController.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/7/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class RecordingsController: ShareButtonTappedDelegate {
    
    static let shared = RecordingsController()
    
    //    var recordButton: UIButton! //Do I need this when I already have that recordingButton IBOutlet?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    func shareButtonTapped() {
        
    }
    
    
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    
    
    var recordings: [Recordings] {
        
        return loadRecordingsFromPersistentStore()
    }
    
    
    func loadRecordingsFromPersistentStore() -> [Recordings] {
        
        let fetchRequest: NSFetchRequest<Recordings> = Recordings.fetchRequest()

        let moc = CoreDataStack.context
        
        do {
            let results = try moc.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching recordings from persistent store")
            return []
        }
    }
    
//    let fetchedResultsController: NSFetchedResultsController<Recordings> = {
//        
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
//        
//        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
//    }()
    
    
    func createRecording(recording: Recordings) {
        
        saveToPersistentStorage()
    }
    
    func deleteRecording(recording: Recordings) {
        
        recording.managedObjectContext?.delete(recording)
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        
        do {
            return try CoreDataStack.context.save()
        } catch {
            print("Did not save!")
        }
    }
    
    
}
