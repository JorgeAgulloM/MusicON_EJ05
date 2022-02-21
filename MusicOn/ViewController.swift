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
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var shuffleControl: UIButton!
    @IBOutlet weak var repeatControl: UIButton!
    
    
    var player: AVAudioPlayer!
    var playList: Array<SoundTrack> = []
    var soundLoaded: Int = 0
    let minSound: Int = 0
    var maxSound: Int = 0 //playList.count
    var touchSlider: Bool = false
    var shuffleSong: Bool = false
    var repeatSong: Bool = false
    var randomlist: Array<Int> = []
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Carga canciones
        loadSoundTracks()
        
        //  Carga la plrimera en el reproductor
        initPlayer()
        
        // Carga el valor del array de canciones
        maxSound = playList.count - 1
        
    }
    
    //  Carga la canción a reproducir
    func initPlayer() {
        let url = Bundle.main.url(forResource: playList[soundLoaded].url, withExtension: playList[soundLoaded].typeOf)
        player = try? AVAudioPlayer(contentsOf: url!)
        infoPlayer()
    }
    
    //  Prepara los datos de la canción a reproducir
    func infoPlayer() {
        imageSong.image = playList[soundLoaded].image
        titleLabelSong.text = playList[soundLoaded].title
        artistLabelSong.text = playList[soundLoaded].artist
        updateTimerDurationLabel()
        updateTimeCurrentLabel()
    }
    
    //  Función para iniciar o parar la reproducción
    func playPause(_ startStop: Bool) {
        if startStop {
            sliderControl.maximumValue = Float(player.duration)
            
            //  Timer para actualizar el Slider
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { second in
                if self.touchSlider {
                    self.updateTimeCurrentLabelForSlider()
                } else {
                    self.updateSlider()
                    self.updateTimeCurrentLabel()
                }
                
                if self.player.isPlaying {
                    if (self.player.duration - 1) <= self.player.currentTime {
                        if !self.repeatSong {
                            self.nextSound()
                            
                        } else {
                            self.initPlayer()
                            self.playPause(true)
                        }
                    }
                }
            }
            
            player.play()
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            timer.invalidate()
            player.pause()
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }

    //  Actualiza el slider
    func updateSlider() {
        sliderControl.value = Float(player.currentTime)
    }
    
    //  Función para pasar a la siguiente canción. Tiene en cuenta si el shuffle está activo
    func nextSound() {
        if shuffleSong {
            if randomlist.count > 0 {
                soundLoaded = randomlist[0]
            } else {
                generateRandom()
                soundLoaded = randomlist[0]
            }
            randomlist.remove(at: 0)
            print(randomlist)
            
        } else {
            soundLoaded = soundLoaded == maxSound ? minSound : soundLoaded + 1
            
        }
        
        initPlayer()
        playPause(true)
    }
    
    //  Actualiza los timers de reproducción de la pista
    func updateTimerDurationLabel() {
        labelDuration.text = formatTimers(Int(player.duration))
    }
    
    func updateTimeCurrentLabel() {
        labelCurrentTime.text = formatTimers(Int(player.currentTime))
    }
    
    func updateTimeCurrentLabelForSlider() {
        labelCurrentTime.text = formatTimers(Int(sliderControl.value))
    }
    
    //  Da formato a los timers de reproducción de la pista
    func formatTimers(_ time: Int) -> String{
        var value: Int = Int(time)
        var valueString: String = ""
        var min: Int = 0
        var sec: Int = 0
        
        repeat {
            if value >= 60 {
                min += 1
                value -= 60
            } else {
                sec = value
                value = 0
            }
            
        } while value > 0
        
        if min < 10 {
            valueString = sec < 10 ? "0\(min):0\(sec)" : "0\(min):\(sec)"
        } else {
            valueString = sec < 10 ? "\(min):0\(sec)" : "\(min):\(sec)"
        }
        
        return valueString
    }
    
    //  Genera un array de canciónes shuffle
    func generateRandom() {
        for n in 0..<playList.count {
            randomlist.append(n)
            
        }
        
        randomlist.shuffle()
    }
    
    //  Modifica el timeCurrent de la canción al dejar de tocar el Slider
    @IBAction func sliderTouchUpInside(_ sender: UISlider) {
        touchSlider = false
        player.currentTime = TimeInterval(sliderControl.value)
        player.prepareToPlay()
        playPause(true)
    }

    //  Al pulsar sobre la barra para cambiar el tiempo de reproducción se bloquea la actualización de la canción momentaneamente paa evitar saltos de canción mientra se toca el Slider
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        touchSlider = true
    }
    
    //  Acción para cambiar el valor de la label al editar el valor del Slider
    @IBAction func sliderEditingChanged(_ sender: UISlider) {
        updateTimeCurrentLabel()
    }
    
    //  Acción para pasar a play, pause o vicebersa
    @IBAction func playControl(_ sender: UIButton) {
        if player.isPlaying {
            playPause(false)
        } else {
            playPause(true)
        }
        
    }
    
    //  Acción para ir a la canción anterior
    @IBAction func backwardControl(_ sender: UIButton) {
        if soundLoaded == minSound {
            soundLoaded = maxSound
        } else {
            soundLoaded -= 1
        }
        initPlayer()
        playPause(true)
    }
    
    //  Acción para pasar a la siguiente canción
    @IBAction func forwardControl(_ sender: UIButton) {
        nextSound()
    }
    
    //  Acción para poner la lista a reproducir en modo shuffle
    @IBAction func shuffleButtonControl(_ sender: UIButton) {
        shuffleSong.toggle()
        if shuffleSong {
            shuffleControl.tintColor = .green
            randomlist.removeAll()
            generateRandom()
            soundLoaded = randomlist[0]
            randomlist.remove(at: 0)
            if !player.isPlaying {
                initPlayer()
                playPause(true)
            }
            
        } else {
            shuffleControl.tintColor = .gray
            
        }
    }
    
    //  Acción del botón para repetir canción
    @IBAction func repeatButtonControl(_ sender: UIButton) {
        repeatSong.toggle()
        if repeatSong {
            repeatControl.tintColor = .green
        } else {
            repeatControl.tintColor = .gray
        }
        
    }
    
    //  Carga de canciones de la app
    func loadSoundTracks() {
        playList.append(SoundTrack(rawName: "ImmigrantSong(Remaster).mp3"))
        playList.append(SoundTrack(rawName: "Interstellar.mp3"))
        playList.append(SoundTrack(rawName: "InTheEnd.mp3"))
        playList.append(SoundTrack(rawName: "LoseYourself.mp3"))
        playList.append(SoundTrack(rawName: "Sandstorm.mp3"))
        playList.append(SoundTrack(rawName: "ShootToThrill.mp3"))
        playList.append(SoundTrack(rawName: "Song2.mp3"))
        playList.append(SoundTrack(rawName: "Spider-Verse(NoWayHomeTribute).mp3"))
        playList.append(SoundTrack(rawName: "StandByMe.mp3"))
        playList.append(SoundTrack(rawName: "Thunderstruck.mp3"))
    
    }
    
}

