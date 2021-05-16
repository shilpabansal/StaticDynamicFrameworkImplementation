//
//  FeedListViewController.swift
//  LibraryAndFrameworks
//
//  Created by Shilpa Bansal on 23/01/21.
//

import UIKit
import FeedContent

class FeedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var feedTableView: UITableView!
    var feedViewModel: FeedListViewModel?
    var coordinator: FeedCoordinator?
    
    let cellReuseIdentifier = "FeedCell"
    
    @IBOutlet var tableView: UITableView!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel?.numberOfFeeds ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.feedTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
            if let cellText = feedViewModel?.item(at: indexPath.row) {
                cell.textLabel?.text = cellText
            }
            return cell
        }
        return UITableViewCell()
    }
}

