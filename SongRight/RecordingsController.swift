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

class RecordingsController: NSObject, ShareButtonTappedDelegate, AVAudioRecorderDelegate {
    
    static let shared = RecordingsController()
    
    //    var recordButton: UIButton! //Do I need this when I already have that recordingButton IBOutlet?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var playAudio: AVAudioPlayer!
    var audioAsset: AVAsset!
    
    let recording = Recordings()
    
    func shareButtonTapped() {
        
    }
    
    
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    //MOVE ALL OF MY AVFOUNDATION STUFF FROM THE RECORDINGSVIEWCONTROLLER INTO THIS RECORDINGSCONTROLLER!
    
    
    var recordings: [Recordings]? {
        
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
    
    func playRecording(recording: Recordings) {
        
        loadRecordingsFromPersistentStore()
        playAudio.play()
    }
    
    func pauseRecording(recording: Recordings) {
        
        playAudio.pause()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        
        //THIS IS WRONG, I'M NOT USING THIS DOCUMENTS DIRECTORY, I'M USING CORE DATA
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            RecordingsController.shared.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            RecordingsController.shared.audioRecorder.delegate = self
            RecordingsController.shared.audioRecorder.record()
            
            //            recordingButton.setTitle("Tap to Stop", for: .normal)
            //            recordingButton.setTitleColor(UIColor.black, for: .normal)
            //
            
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        RecordingsController.shared.audioRecorder.stop()
        RecordingsController.shared.audioRecorder = nil
        
        if success {
            //            recordingButton.setTitle("Tap to Re-record", for: .normal)
            //            recordingButton.setTitleColor(UIColor.red, for: .normal)
            RecordingsController.shared.createRecording(recording: recording)
        } else {
            //            recordingButton.setTitle("Tap to Record", for: .normal)
            //            recordingButton.setTitleColor(UIColor.blue, for: .normal)
            RecordingsController.shared.deleteRecording(recording: recording)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func saveToPersistentStorage() {
        
        do {
            return try CoreDataStack.context.save()
        } catch {
            print("Did not save!")
        }
    }
    
    
}
