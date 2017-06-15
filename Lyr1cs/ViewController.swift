//
//  ViewController.swift
//  Lyr1cs
//
//  Created by Xan Kraegor on 23.04.2017.
//  Copyright © 2017 Anton Alekseev. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var labelsBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noLyricsLabel: UILabel!

    var musicPlayer: MPMusicPlayerController?
    var nowPlayingSong: MPMediaItem? {
        didSet {
            getMetadata()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lyricsTextView.layer.cornerRadius = 10.0
        labelsBackgroundView.layer.cornerRadius = 10.0
        lyricsTextView.clipsToBounds = true

        musicPlayer = MPMusicPlayerController.systemMusicPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playingItemDidChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer!.beginGeneratingPlaybackNotifications()
         imageView.backgroundColor = UIColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        if musicPlayer?.nowPlayingItem != nowPlayingSong {
            nowPlayingSong = musicPlayer?.nowPlayingItem
        }
    }

    func playingItemDidChange(notification: NSNotification) {
        nowPlayingSong = musicPlayer?.nowPlayingItem
    }

    func getMetadata() {
        if let songUrl = nowPlayingSong?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {

            let playerItem = AVURLAsset(url: songUrl, options: nil)
            lyricsTextView.text = playerItem.lyrics
            if playerItem.lyrics != nil {
                noLyricsLabel.isHidden = true
            } else {
                noLyricsLabel.isHidden = false
            }

            lyricsTextView.setContentOffset(CGPoint.zero, animated: true)

            artistLabel.text = nowPlayingSong?.artist ?? "—"
            songTitle.text = nowPlayingSong?.title ?? "—"

            let imageSize = CGSize(width: view.bounds.width, height: view.bounds.height)
            imageView.image = nowPlayingSong?.artwork?.image(at: imageSize)

        } else {
            lyricsTextView.text = ""
            songTitle.text = "—"
            artistLabel.text = ""
        }
    }
}

