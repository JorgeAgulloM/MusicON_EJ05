//
//  ViewController.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 20/2/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var sliderControl: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButtonControl: UIButton!
    @IBOutlet weak var forwardButtonControl: UIButton!
    @IBOutlet weak var titleLabelSong: UILabel!
    @IBOutlet weak var artistLabelSong: UILabel!
    
    var player: AVAudioPlayer!
    var playList: Array<SoundTrack> = []
    var soundLoaded: Int = 0
    let minSound: Int = 0
    var maxSound: Int = 0 //playList.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSoundTracks()
        initPlayer()
        maxSound = playList.count - 1
        
        //  Timer para actualizar el Slider
        var _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { second in
            self.updateSlider()
            if self.player.isPlaying {
                if (self.player.duration - 1) <= self.player.currentTime {
                    self.nextSound()
                }
            }
        }
    }
    
    func initPlayer() {
        let url = Bundle.main.url(forResource: playList[soundLoaded].url, withExtension: playList[soundLoaded].typeOf)
        player = try? AVAudioPlayer(contentsOf: url!)
        infoPlayer()
    }
    
    func infoPlayer() {
        if let image = UIImage(named: playList[soundLoaded].image) {
            imageSong.image = image
        } else {
            print("Error al cargar la imagen")
        }
        
        if let title = playList[soundLoaded].title {
            titleLabelSong.text = title
        } else {
            titleLabelSong.text = "Unknow"
        }
        
        if let artist = playList[soundLoaded].artist {
            artistLabelSong.text = artist
        } else {
            artistLabelSong.text = "Unknow"
        }
    }
    func showPlayPause(_ startStop: Bool) {
        if startStop {
            sliderControl.maximumValue = Float(player.duration)
            player.play()
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            player.pause()
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }

    func updateSlider() {
        sliderControl.value = Float(player.currentTime)
    }
    
    func nextSound() {
        if soundLoaded == maxSound {
            soundLoaded = minSound
        } else {
            soundLoaded += 1
        }
        initPlayer()
        showPlayPause(true)
    }
    
    @IBAction func sliderControl(_ sender: UISlider) {
        player.currentTime = TimeInterval(sliderControl.value)
        player.prepareToPlay()
        showPlayPause(true)
    }
    
    @IBAction func playControl(_ sender: UIButton) {
        if player.isPlaying {
            showPlayPause(false)
        } else {
            showPlayPause(true)
        }
        
    }
    
    @IBAction func backwardControl(_ sender: UIButton) {
        if soundLoaded == minSound {
            soundLoaded = maxSound
        } else {
            soundLoaded -= 1
        }
        initPlayer()
        showPlayPause(true)
    }
    
    @IBAction func forwardControl(_ sender: UIButton) {
        nextSound()
    }
    
    
    
    func loadSoundTracks() {
        playList.append(SoundTrack(url: "ACDC_Thunderstruck", typeOf: "mp3", title: "Thunderstruck", artist: "AC-DC", image: "thunderstruck"))
        playList.append(SoundTrack(url: "ACDC_ShootToThrill", typeOf: "mp3", title: "Shoot To Thrill", artist: "AC-DC", image: "shootToThrill"))
        playList.append(SoundTrack(url: "BenE.King_StandByMe", typeOf: "mp3", title: "Stand By Me", artist: "BenE.King", image: "standByMe"))
        playList.append(SoundTrack(url: "Blur_Song2", typeOf: "mp3", title: "Song 2", artist: "Blur", image: "song2"))
        playList.append(SoundTrack(url: "Eminem_LoseYourself", typeOf: "mp3", title: "Lose Your self", artist: "Eminem", image: "loseYourSelf"))
        playList.append(SoundTrack(url: "LedZeppelin_ImmigrantSong", typeOf: "mp3", title: "Immigrant Song", artist: "LedZeppelin", image: "inmigrantSong"))
        playList.append(SoundTrack(url: "LinkinPark_InTheEnd", typeOf: "mp3", title: "In The End", artist: "LinkinParkC", image: "inTheEnd"))
        playList.append(SoundTrack(url: "Sandstorm_AlexChristensenAndTheBerlinOrchestra", typeOf: "mp3", title: "Sandstorm", artist: "Alex Christensen And The Berlin Orchestra", image: "sandstorm"))
        playList.append(SoundTrack(url: "SamuelKin_SpiderVerseTheme", typeOf: "mp3", title: "Spider-Verse Theme", artist: "Samuel Kim", image: "spiderVerse"))
        playList.append(SoundTrack(url: "Wice_Interstellar", typeOf: "mp3", title: "Interstellar", artist: "Wise", image: "interstellar"))
    }
    
}

