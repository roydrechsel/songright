//
//  ViewController.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/11/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class RecordingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, ShareButtonTappedDelegate, NSFetchedResultsControllerDelegate {
    
    //    var recordButton: UIButton! //Do I need this when I already have that recordingButton IBOutlet?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    let recording = Recordings(title: "My next single!", length: 2, isFavorite: true)
    
    @IBOutlet weak var RecordingsTableView: UITableView!
    @IBOutlet weak var recordingTimer: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    
    
    
    
    
    //IF I MOVE ALL OF THIS STUFF INTO MY RECORDINGS CONTROLLER, WHERE DO I PUT MY OUTLETS?
    
    
    
    let fetchedResultsController: NSFetchedResultsController<Recordings> = {
        
        let fetchRequest: NSFetchRequest<Recordings> = Recordings.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        recordTapped()
        
    }
    //TODO -- UPDATE activityItems TO BE AN ACTUAL RECORDING OBJECT TO SHARE, RATHER THAN JUST THE PLACEHOLDER recording.title THAT I'M SHARING RIGHT NOW
    func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [recording.title], applicationActivities: .none)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func getStringFromDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, H:mm"
        return dateFormatter.string(from: date)
    }
    
//    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
//        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
//        view.addSubview(recordButton)
//    }
    
    func loadRecordingUI() {
        recordingButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        recordingButton.setTitle("Record", for: .normal)
        recordingButton.setTitleColor(UIColor.purple, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI() //I already have a UI built in Storyboard, do I need this? How do I access what i have built? Put it in the loadRecordingUI func? Or reference it here?
                    } else {
                        //failed to record
                    }
                }
            }
        } catch {
            //failed to record
    }
        
//        RecordingsTableView.delegate = self
//        RecordingsTableView.dataSource = self
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func recordTapped() {
        
        if audioRecorder == nil {
            
            startRecording()
        } else {
            finishRecording(success: true)
        }
        
//        RecordingsViewController.updateTimer(_:)
    }
    
    func updateTimer(_ timer: Timer) {
        
        if audioRecorder.isRecording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let timerString = String(format: "%02d:%02d", min, sec)
            
            recordingTimer.text = timerString
            audioRecorder.updateMeters()
        }
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
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordingButton.setTitle("Tap to Stop", for: .normal)
            recordingButton.setTitleColor(UIColor.black, for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordingButton.setTitle("Tap to Re-record", for: .normal)
            recordingButton.setTitleColor(UIColor.red, for: .normal)
        } else {
            recordingButton.setTitle("Tap to Record", for: .normal)
            recordingButton.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
//        return RecordingsController.shared.recordings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as? RecordingsCustomTableViewCell else { return UITableViewCell() }
        
//        let recording = RecordingsController.shared.recordings[indexPath.row]
        cell.title.text = recording.title
        cell.date.text = getStringFromDate(date: Date())
//        cell.length.text = recording.length
//        cell.backgroundColor = UIColor.brown
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - NSFetchResultsControllerDelegate
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .delete:
//            guard let indexPath = indexPath else { return }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        case .insert:
//            guard let newIndexPath = newIndexPath else { return }
//            tableView.insertRows(at: [newIndexPath], with: .top)
//        case.update:
//            guard let indexPath = indexPath else { return }
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        case.move:
//            guard let indexPath = indexPath,
//                let newIndexPath = newIndexPath else { return }
//            tableView.moveRow(at: indexPath, to: newIndexPath)
//            
//        }
//    }
    
}
