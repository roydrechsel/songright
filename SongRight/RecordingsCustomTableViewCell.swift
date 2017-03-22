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
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
