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

class RecordingsController: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let shared = RecordingsController()
    
    //    var recordButton: UIButton! //Do I need this when I already have that recordingButton IBOutlet?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    var playAudio: AVAudioPlayer?
    var audioAsset: AVAsset!
    var soundFileURL: URL!
    
    let recording = Recordings()
    
    
    
    
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
    
    func playRecording(recording: [Recordings]) {
        
//        loadRecordingsFromPersistentStore()
        
        var selectedRecording: URL?
        if self.audioRecorder != nil {
            selectedRecording = self.audioRecorder?.url
        } else {
            selectedRecording = self.soundFileURL!
        }
        print("Playing \(selectedRecording)")
        
        do {
            self.playAudio = try AVAudioPlayer(contentsOf: selectedRecording!)
            //stopButton.isEnabled = true       I HAVEN'T WRITTEN FUNCTIONALITY FOR A STOP BUTTON, SINCE I'M SHARING PLAY/PAUSE/STOP
            playAudio?.delegate = self
            playAudio?.prepareToPlay()
            playAudio?.volume = 1.0
            playAudio?.play()
        } catch let error as NSError {
            self.playAudio = nil
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            playAudio = nil
            print(error.localizedDescription)
        }
        
    }
    
    func pauseRecording(recording: Recordings) {
        
        playAudio?.pause()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            RecordingsController.shared.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            RecordingsController.shared.audioRecorder?.delegate = self
            RecordingsController.shared.audioRecorder?.record()
            
            //            recordingButton.setTitle("Tap to Stop", for: .normal)
            //            recordingButton.setTitleColor(UIColor.black, for: .normal)
            //
            
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        RecordingsController.shared.audioRecorder?.stop()
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
