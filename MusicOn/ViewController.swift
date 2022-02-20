//
//  ViewController.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 20/2/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    var player: AVAudioPlayer!
    var playList: Array<SoundTrack> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSoundTracks()
        initPlayer(0)
    }

    func initPlayer(_ track: Int) {
        let url = Bundle.main.url(forResource: playList[track].url, withExtension: playList[track].typeOf)
        player = try? AVAudioPlayer(contentsOf: url!)
    }

    @IBAction func playControl(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        
    }
    
    
    func loadSoundTracks() {
        playList.append(SoundTrack(url: "ACDC_Thunderstruck", typeOf: "mp3", title: "Thunderstruck", artist: "AC-DC", image: "thunderstruck"))
        playList.append(SoundTrack(url: "ACDC_ShootToThrill", typeOf: "mp3", title: "Shoot To Thrill", artist: "AC-DC", image: "ShootToThrill"))
        playList.append(SoundTrack(url: "BenE.King_StandByMe", typeOf: "mp3", title: "Stand By Me", artist: "BenE.King", image: "standByMe"))
        playList.append(SoundTrack(url: "Blur_Song2", typeOf: "mp3", title: "Song 2", artist: "Blur", image: "song2"))
        playList.append(SoundTrack(url: "Eminem_LoseYourself", typeOf: "mp3", title: "Lose Your self", artist: "Eminem", image: "loseYourself"))
        playList.append(SoundTrack(url: "LedZeppelin_ImmigrantSong", typeOf: "mp3", title: "Immigrant Song", artist: "LedZeppelin", image: "immigrantSong"))
        playList.append(SoundTrack(url: "LinkinPark_InTheEnd", typeOf: "mp3", title: "In The End", artist: "LinkinParkC", image: "inTheEnd"))
        playList.append(SoundTrack(url: "Sandstorm_AlexChristensenAndTheBerlinOrchestra", typeOf: "mp3", title: "Sandstorm", artist: "Alex Christensen And The Berlin Orchestra", image: "sandstorm"))
        playList.append(SoundTrack(url: "SamuelKin_SpiderVerseTheme", typeOf: "mp3", title: "Spider-Verse Theme", artist: "Samuel Kim", image: "spiderVerseTheme"))
        playList.append(SoundTrack(url: "Wice_Interstellar", typeOf: "mp3", title: "Interstellar", artist: "Wise", image: "interstellar"))
    }
    
}

