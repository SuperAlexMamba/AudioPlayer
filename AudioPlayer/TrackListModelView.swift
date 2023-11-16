//
//  Manager.swift
//  AudioPlayer
//
//  Created by Слава Орлов on 16.11.2023.
//

import Foundation
import AVFoundation
import MediaPlayer

class TrackListModelView {
    
    static let shared = TrackListModelView()
    
    private init() {}
    
    var tracksArray: [Track] = []
    
    func getTracks() async {
                
        let directoryPath = Bundle.main.resourcePath!
        
        let fileManager = FileManager.default
        
        do {
            
            let items = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            for item in items {
                if item.hasSuffix(".mp3") {
                    let url = URL(fileURLWithPath: directoryPath).appendingPathComponent(item)
                    let playerItem = AVPlayerItem(url: url)
                    
                    if let metadata = try await playerItem.asset.load(.commonMetadata).first(where: { $0.commonKey == AVMetadataKey.commonKeyTitle }),
                       let title = try await metadata.load(.value) as? String,
                       let artist = try await playerItem.asset.load(.commonMetadata).first(where: { $0.commonKey == AVMetadataKey.commonKeyArtist })?.load(.value) as? String {
                        
                        let duration = await CMTimeGetSeconds( try playerItem.asset.load(.duration))
                        let track = Track(title: title, duration: duration, artist: artist, url: url)
                        tracksArray.append(track)
                    }
                }
            }
        }
        catch {
            print("Ошибка получения треков: \(error.localizedDescription)")
        }
    }
    
    func loadTracks(in tableView: UITableView) {
        
        Task {
            await getTracks()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
        
    }
    
}
