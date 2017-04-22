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
    
    private let lastSelectedCellIndexPathSectionKey = "lastSelectedCellIndexPathSection"
    private let lastSelectedCellIndexPathRowKey = "lastSelectedCellIndexPathRow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteRecordingsTableView.delegate = self
        FavoriteRecordingsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.FavoriteRecordingsTableView.reloadData()
        
        guard let section = UserDefaults.standard.value(forKey: lastSelectedCellIndexPathSectionKey) as? Int,
            let row = UserDefaults.standard.value(forKey: lastSelectedCellIndexPathRowKey) as? Int else { return }
        let selectedIndexPath = IndexPath(row: row, section: section)
        FavoriteRecordingsTableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RecordingsController.shared.recordings?.filter({$0.isFavorite}).count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as? RecordingsCustomTableViewCell else { return UITableViewCell() }
        
        let favoriteRecording = RecordingsController.shared.recordings?.filter({$0.isFavorite})[indexPath.row]
        
        cell.recording = favoriteRecording
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.section, forKey: lastSelectedCellIndexPathSectionKey)
        UserDefaults.standard.set(indexPath.row, forKey: lastSelectedCellIndexPathRowKey)
    }
    
}
