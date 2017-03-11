//
//  RecordingsCustomTableViewCell.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/9/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit

class RecordingsCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favorite: UILabel!
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        
        
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
