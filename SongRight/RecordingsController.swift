//
//  RecordingsController.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/7/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingsController: ShareButtonTappedDelegate {
    
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
    
    static let shared = RecordingsController()
    
    var recordings = [Recordings]()
    
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
