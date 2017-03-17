//
//  FavoriteRecordingsViewController.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/11/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import UIKit

class FavoriteRecordingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var FavoriteRecordingsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RecordingsController.shared.recordings.filter({$0.isFavorite}).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as? RecordingsCustomTableViewCell else { return UITableViewCell() }
        
        let favoriteRecording = RecordingsController.shared.recordings.filter({$0.isFavorite})
        cell.title.text = favoriteRecording.description
        
        return cell
    }
    
    
}
