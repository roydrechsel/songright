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
    
    //    let recording = Recordings(title: "My next single!", length: 2, isFavorite: true)?
    let recording = Recordings()
    
    @IBOutlet weak var RecordingsTableView: UITableView!
    @IBOutlet weak var recordingTimer: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    
    var isRecording = false
    
    
    //IF I MOVE ALL OF THIS STUFF INTO MY RECORDINGS CONTROLLER, WHERE DO I PUT MY OUTLETS?
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if isRecording == false {
            isRecording = true
            
            RecordingsController.shared.startRecording()
            recordingButton.setTitle("Stop", for: .normal)
            recordingButton.setTitleColor(UIColor.black, for: .normal)
//            }
        } else {
            isRecording = false
            if RecordingsController.shared.audioRecorder != nil && RecordingsController.shared.audioRecorder.isRecording {
                
                let alertController = UIAlertController(title: "Save Recording", message: "Give it a great title:", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let newRecordingTitle = alertController.textFields?.first?.text else { return }
                    let newRecording = Recordings(title: newRecordingTitle, timestamp: Date(), length: 6.66, isFavorite: false, context: CoreDataStack.context)
                    RecordingsController.shared.createRecording(recording: newRecording)
                    
                    self.RecordingsTableView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in }
                
                alertController.addTextField { (textField: UITextField) -> Void in }
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                RecordingsController.shared.finishRecording(success: true)
                recordingButton.setTitle("Record", for: .normal)
                recordingButton.setTitleColor(UIColor.red, for: .normal)

            } else {
                return
            }
        }
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
    //        recordingButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    //        recordingButton.setTitle("Record", for: .normal)
    //        recordingButton.setTitleColor(UIColor.purple, for: .normal)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecordingsController.shared.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try RecordingsController.shared.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try RecordingsController.shared.recordingSession.setActive(true)
            RecordingsController.shared.recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordingButton.addTarget(self, action: #selector(self.recordButtonTapped), for: .touchUpInside)
                        self.recordingButton.setTitle("Record", for: .normal)
                        self.recordingButton.setTitleColor(UIColor.red, for: .normal)
                        
                        //                        self.loadRecordingUI() //I already have a UI built in Storyboard, do I need this? How do I access what i have built? Put it in the loadRecordingUI func? Or reference it here?
                    } else {
                        //failed to record
                    }
                }
            }
        } catch {
            //failed to record
        }
        
        RecordingsTableView.delegate = self
        RecordingsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        RecordingsTableView.reloadData()
    }
    
    
    func updateTimer(_ timer: Timer) {
        
        if RecordingsController.shared.audioRecorder.isRecording {
            let min = Int(RecordingsController.shared.audioRecorder.currentTime / 60)
            let sec = Int(RecordingsController.shared.audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let timerString = String(format: "%02d:%02d", min, sec)
            
            recordingTimer.text = timerString
            RecordingsController.shared.audioRecorder.updateMeters()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return 1
        return RecordingsController.shared.recordings!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as? RecordingsCustomTableViewCell else { return UITableViewCell() }
        
        let recording = RecordingsController.shared.recordings?[indexPath.row]
        cell.title.text = recording?.title
        cell.date.text = getStringFromDate(date: Date())
        //        cell.length.text = recording.length
        //        cell.backgroundColor = UIColor.brown
        cell.delegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let recordingToDelete = RecordingsController.shared.recordings?[indexPath.row] {
                RecordingsController.shared.deleteRecording(recording: recordingToDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
