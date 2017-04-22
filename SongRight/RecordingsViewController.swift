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
import CoreMedia

class RecordingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, ShareButtonTappedDelegate, PlayPauseButtonTappedDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var RecordingsTableView: UITableView!
    @IBOutlet weak var recordingTimer: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    
    private var recordings: [Recordings]?
    private let lastSelectedCellIndexPathSectionKey = "lastSelectedCellIndexPathSection"
    private let lastSelectedCellIndexPathRowKey = "lastSelectedCellIndexPathRow"
    var recording: Recordings?
    
    var timer: Timer?
    
    var searchBarActive: Bool = false
    var filteredRecordings = [Recordings]()
//    let recording = RecordingsController.shared.recordings?.filter({ $0.recordingURL != nil && $0.recordingURL!.characters.count > 0 })

    var isRecording = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        RecordingsTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for Title"
        
        
        recordingTimer.isHidden = true
        
        RecordingsController.shared.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try RecordingsController.shared.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try RecordingsController.shared.recordingSession.setActive(true)
            RecordingsController.shared.recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordingButton.addTarget(self, action: #selector(self.recordButtonTapped), for: .touchUpInside)
                        self.recordingButton.setTitle("Record", for: .normal)
                        self.recordingButton.setTitleColor(UIColor.white, for: .normal)
                        
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
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if isRecording == false {
            recordingTimer.isHidden = false
            isRecording = true
            
            RecordingsController.shared.startRecording()
            recordingButton.setTitle("Stop", for: .normal)
            recordingButton.setTitleColor(UIColor.black, for: .normal)
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(updateTimer(_:)),
                                              userInfo: nil,
                                              repeats: true)
            
        } else {
            isRecording = false
            guard let audioRecorder = RecordingsController.shared.audioRecorder else { return }

            if audioRecorder.isRecording {
                RecordingsController.shared.finishRecording(success: true)
                
                let alertController = UIAlertController(title: "Save Recording", message: "Give it a great title:", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self] (action: UIAlertAction) -> Void in
                    
                    guard let newRecordingTitle = alertController.textFields?.first?.text, let soundFileURL = RecordingsController.shared.soundFileURL?.absoluteString else { return }
                    let newRecording = Recordings(title: newRecordingTitle,
                                                  timestamp: Date(),
                                                  length: 6.66,
                                                  isFavorite: false,
                                                  recordingURL: soundFileURL,
                                                  context: CoreDataStack.context)
                    RecordingsController.shared.createRecording(recording: newRecording)
                    
                    self.updateRecordingsFromRecordingsController()
                    self.RecordingsTableView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in }
                
                alertController.addTextField { (textField: UITextField) -> Void in }
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                recordingButton.setTitle("Record", for: .normal)
                recordingButton.setTitleColor(UIColor.white, for: .normal)
                recordingTimer.isHidden = true

            } else {
                return
            }
        }
    }
    
    //TODO -- UPDATE activityItems TO BE AN ACTUAL RECORDING OBJECT TO SHARE, RATHER THAN JUST THE PLACEHOLDER THAT I'M SHARING RIGHT NOW
    func shareButtonTapped() {
//        let recording = RecordingsController.shared.recording
        let activityViewController = UIActivityViewController(activityItems: ["How do I share the actual recording?"], applicationActivities: .none)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
//    func getStringFromDate(date: Date) -> String {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yy H:mm"
//        return dateFormatter.string(from: date)
//    }
    
    private func updateRecordingsFromRecordingsController()
    {
        recordings = RecordingsController.shared.recordings?.filter({ $0.recordingURL != nil && $0.recordingURL!.characters.count > 0 })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateRecordingsFromRecordingsController()
        self.RecordingsTableView.reloadData()
        
        guard let section = UserDefaults.standard.value(forKey: lastSelectedCellIndexPathSectionKey) as? Int,
        let row = UserDefaults.standard.value(forKey: lastSelectedCellIndexPathRowKey) as? Int else { return }
        let selectedIndexPath = IndexPath(row: row, section: section)
        RecordingsTableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    
    func updateTimer(_ timer: Timer) {
        guard let audioRecorder = RecordingsController.shared.audioRecorder else { return }
        if audioRecorder.isRecording {
            
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let timerString = String(format: "%02d:%02d", min, sec)
            
            recordingTimer.text = timerString
            audioRecorder.updateMeters()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRecordings.count
        } else {
            return recordings?.count ?? 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as? RecordingsCustomTableViewCell else { return UITableViewCell() }
        
        if searchController.isActive && searchController.searchBar.text != "" {
            let recording = filteredRecordings[indexPath.row]
            cell.recording = recording
            cell.delegate = self
            cell.playPauseButtonDelegate = self
            RecordingsController.shared.audioFinishedPlayingDelegate = cell
            return cell
        } else {
        
        let recording = recordings?[indexPath.row]
        
            cell.recording = recording
            cell.delegate = self
            cell.playPauseButtonDelegate = self
            RecordingsController.shared.audioFinishedPlayingDelegate = cell
            return cell
            
        }
    }
    
    func playPauseButtonTapped(sender: RecordingsCustomTableViewCell) {
        RecordingsController.shared.audioFinishedPlayingDelegate = sender
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let recordingToDelete = recordings?[indexPath.row] {
                RecordingsController.shared.deleteRecording(recording: recordingToDelete)
            }
            updateRecordingsFromRecordingsController()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.section, forKey: lastSelectedCellIndexPathSectionKey)
        UserDefaults.standard.set(indexPath.row, forKey: lastSelectedCellIndexPathRowKey)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        if let recordings = recordings {
        filteredRecordings = recordings.filter { recordings  in
            return (recordings.title?.lowercased().contains(searchText.lowercased()))!
            }
        }
        
        self.RecordingsTableView.reloadData()
    }
    
}

extension RecordingsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CMTime {
    var durationText:String {
        let totalSeconds = self.seconds
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
