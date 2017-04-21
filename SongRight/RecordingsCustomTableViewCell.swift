//
//  RecordingsCustomTableViewCell.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/9/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit
import AVFoundation

protocol ShareButtonTappedDelegate: class {
    func shareButtonTapped()
}

protocol PlayPauseButtonTappedDelegate: class {
    func playPauseButtonTapped()
}

class RecordingsCustomTableViewCell: UITableViewCell {

    weak var delegate: ShareButtonTappedDelegate?
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var isFavorite = false
    var isPlaying = false
    
    var recording: Recordings?
        {
        didSet {
            updateViews()
        }
    }
    
    func stringFromDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy H:mm"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        if isFavorite == false {
            favoriteButton.setBackgroundImage(UIImage(named: "Favorite Selected"), for: UIControlState.normal)
                isFavorite = true
            if let recording = recording {
                recording.isFavorite = true
            }
            
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "Favorite Deselected"), for: UIControlState.normal)
                isFavorite = false
            if let recording = recording {
                recording.isFavorite = false
            }
        }
        //WRITE A FUNCTION IN MY RECORDINGSCONTROLLER THAT DOES THIS WORK, THEN CALL THAT FUNCTION HERE
        
        RecordingsController.shared.saveToPersistentStorage()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        
        if let playableRecording = self.recording {
            
            if isPlaying == false {
                playPauseButton.setTitle("Stop", for: .normal)
                playPauseButton.setTitleColor(UIColor.black, for: .normal)
                isPlaying = true
                RecordingsController.shared.playRecording(recording: playableRecording)
            } else {
                playPauseButton.setTitle("Play", for: .normal)
                playPauseButton.setTitleColor(UIColor.blue, for: .normal)
                isPlaying = false
                RecordingsController.shared.pauseRecording(recording: playableRecording)
            }
        }
        
        setSessionPlayback()
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        delegate?.shareButtonTapped()
    }
    
    
    func updateViews() {
//        guard let recording = recording else { return }
//            , let stringFromDate = stringFromDate else { return }
//        title.text = recording.title
//        date.text = stringFromDate
//        date.text = recording.timestamp
//        length.text = "6.66"
        
        if let recording = recording
        {
            title.text =  recording.title
            date.text = stringFromDate(date: recording.timestamp as! Date)
            length.text = "6.66"
            playPauseButton.setTitle("Play", for: .normal)
            playPauseButton.setTitleColor(UIColor.blue, for: .normal)
            
            if recording.isFavorite == true {
                favoriteButton.setBackgroundImage(UIImage(named: "Favorite Selected"), for: UIControlState.normal)
            }
        }
    }

    func setSessionPlayback() {
        
        let session: AVAudioSession = RecordingsController.shared.recordingSession
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("Could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("Could not set session as active")
            print(error.localizedDescription)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
