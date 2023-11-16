//
//  Model.swift
//  AudioPlayer
//
//  Created by Слава Орлов on 16.11.2023.
//

import Foundation

class Track {
    
    var title: String
    var duration: TimeInterval
    var artist: String
    var url: URL
    
    init(title: String, duration: TimeInterval, artist: String, url: URL) {
        self.title = title
        self.duration = duration
        self.artist = artist
        self.url = url
    }
    
}
