//
//  CurrentTrackController.swift
//  AudioPlayer
//
//  Created by Слава Орлов on 18.11.2023.
//

import UIKit
import AVFoundation

class CurrentTrackController: UIViewController {
            
    var selectedTrack: [Track]?
    
    var selectedIndex: Int = 0
        
    var player: AVPlayer?
    
    var timeObserver: Any?
    
    var started: Bool = false
        
    lazy var trackNameLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = selectedTrack?[selectedIndex].title
        
        label.font = .systemFont(ofSize: 25)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var trackTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var currentTimeLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var trackArtistLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = selectedTrack?[selectedIndex].artist
        
        label.font = .systemFont(ofSize: 15)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var progressTrack: UIProgressView = {
        
        let progress = UIProgressView()
        
        progress.translatesAutoresizingMaskIntoConstraints = false
       
        return progress
    }()
    
    lazy var closeButton = UIButton.createButton(title: "Close", 
                                                 image: nil,
                                                 titleColor: .systemBlue, .black)
    
    lazy var playButton = UIButton.createButton(title: nil, 
                                                image: UIImage(systemName: "play"),
                                                titleColor: .systemBlue, .black)
    
    lazy var previouslyButton = UIButton.createButton(title: nil, 
                                                      image: UIImage(systemName: "backward.end"),
                                                      titleColor: .systemBlue, .black)
    
    lazy var nextButton = UIButton.createButton(title: nil, 
                                                image: UIImage(systemName: "forward.end"),
                                                titleColor: .systemBlue, .black)
        
    
    lazy var hStack: UIStackView = {
        
        let stack = UIStackView()
        
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 15
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupConstraints()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    @objc func playTrack() {
                
        if !started {
            
            self.playButton.setImage(UIImage(systemName: "pause"), for: .normal)
            
            guard let url = selectedTrack?[selectedIndex].url else { return }
            
            let playerItem = AVPlayerItem(url: url)

            self.player = AVPlayer(playerItem: playerItem)
            
            player?.volume = 1
            player?.allowsExternalPlayback = true
            player?.appliesMediaSelectionCriteriaAutomatically = true
            player?.automaticallyWaitsToMinimizeStalling = true
            
            let interval = CMTime(value: 1, timescale: 2)
            self.timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { time in
                
                let totalSeconds = CMTimeGetSeconds(playerItem.duration)
                let currentSeconds = CMTimeGetSeconds(time)
                let progress = Float(currentSeconds / totalSeconds)
                self.progressTrack.progress = progress
                self.trackTimeLabel.text = self.formatTime(totalSeconds)
                self.currentTimeLabel.text = self.formatTime(currentSeconds)
                self.trackNameLabel.text = self.selectedTrack![self.selectedIndex].title
                self.trackArtistLabel.text = self.selectedTrack![self.selectedIndex].artist
                
                if currentSeconds == totalSeconds {
                    self.nextTrack()
                }
                
                
            })
            player?.play()
            started = true
            
        }
        
        else {
            self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
            player?.pause()
            started = false
        }
            
    }
        
    @objc func previousTrack() {
        if selectedIndex > 0 {
            selectedIndex -= 1
            playTrack()
            view.updateFocusIfNeeded()
        }
    }

    @objc func nextTrack() {
        if let tracksCount = selectedTrack?.count, selectedIndex < tracksCount - 1 {
            selectedIndex += 1
            playTrack()
            view.updateFocusIfNeeded()
        }
    }
    
    private func setupView() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(closeButton)
        view.addSubview(trackNameLabel)
        view.addSubview(trackArtistLabel)
        view.addSubview(progressTrack)
        view.addSubview(hStack)
        view.addSubview(trackTimeLabel)
        view.addSubview(currentTimeLabel)
        
        hStack.addArrangedSubview(previouslyButton)
        hStack.addArrangedSubview(playButton)
        hStack.addArrangedSubview(nextButton)
        
        playButton.addTarget(self, action: #selector(playTrack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        previouslyButton.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
    }
    
    private func setupConstraints() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            closeButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
                        
            trackNameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            trackNameLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            trackArtistLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 5),
            trackArtistLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            progressTrack.topAnchor.constraint(equalTo: trackArtistLabel.bottomAnchor, constant: 50),
            progressTrack.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 15),
            progressTrack.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15),
            
            trackTimeLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15),
            trackTimeLabel.bottomAnchor.constraint(equalTo: progressTrack.topAnchor, constant: -10),
            trackTimeLabel.heightAnchor.constraint(equalToConstant: 10),
            trackTimeLabel.widthAnchor.constraint(equalToConstant: 30),
            
            currentTimeLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 15),
            currentTimeLabel.bottomAnchor.constraint(equalTo: progressTrack.topAnchor, constant: -10),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 10),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 30),
            
            hStack.topAnchor.constraint(equalTo: progressTrack.bottomAnchor, constant: 50),
            hStack.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 150),
            hStack.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -150)
        
        
        ])
        
    }
        
}
