//
//  MainViewController.swift
//  AudioPlayer
//
//  Created by Слава Орлов on 16.11.2023.
//

import UIKit

class TrackListViewController: UITableViewController {
    
    let modelView = TrackListModelView.shared

    override func viewDidLoad() {
        super.viewDidLoad()
                
        modelView.loadTracks(in: tableView)
        
        setupView()
        
    }
    
    private func setupView() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
                        
        print("MainController")
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return modelView.tracksArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentVC = CurrentTrackController()
        
        currentVC.selectedTrack = modelView.tracksArray
        
        currentVC.selectedIndex = indexPath.row
        
        self.present(currentVC, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = modelView.tracksArray[indexPath.row]
        
        var content = UIListContentConfiguration.cell()
        
        content.textProperties.font = .boldSystemFont(ofSize: 15)
        
        content.text = "\(item.title) - \(item.artist)"
        
        cell.contentConfiguration = content
        
        print(item.artist)
        
        return cell
    }

}
