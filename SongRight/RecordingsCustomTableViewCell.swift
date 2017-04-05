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
    
    var isFavorite = false
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        if isFavorite == false {
            
            favoriteButton.imageView?.image = UIImage(cgImage: #imageLiteral(resourceName: "Favorite Selected") as! CGImage)
            isFavorite = true
            
        } else {
                favoriteButton.imageView?.image = UIImage(cgImage: #imageLiteral(resourceName: "Favorite Deselected") as! CGImage)
                isFavorite = false
        }
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        
        if let playableRecording = RecordingsController.shared.recordings {
         
            RecordingsController.shared.playRecording(recording: playableRecording)
        }
        setSessionPlayback()
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        delegate?.shareButtonTapped()
    }
    
    
    func updateViews() {
        
        title.text = recording?.title
//        date. = recording?.timestamp
//        length.text = recording?.length
//        
    }
    
    var recording: Recordings? {
        
        didSet {
            updateViews()
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
    
    func play() {
        
//        var recording:
//        if self.audioRecorder != nil {
//            recording = self.audioRecorder.recording
//        }
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
