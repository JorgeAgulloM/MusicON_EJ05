//
//  ViewController.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 20/2/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellDelegate {

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
    @IBOutlet weak var myListPlayer: UITableView!
    
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
        
        //Control de la tabla
        myListPlayer.delegate = self
        myListPlayer.dataSource = self
    }
    
    //  Carga la canción a reproducir
    func initPlayer() {
        let url = Bundle.main.url(forResource: playList[soundLoaded].url, withExtension: playList[soundLoaded].typeOf)
        player = try? AVAudioPlayer(contentsOf: url!)
        myListPlayer.reloadData()
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
                            self.nextOrBackSound(1)
                            
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
            playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }

    //  Actualiza el slider
    func updateSlider() {
        sliderControl.value = Float(player.currentTime)
    }
    
    //  Función para pasar a la siguiente o anterior canción. Tiene en cuenta si el shuffle está activo
    func nextOrBackSound(_ goTo: Int) {
        if shuffleSong {
            let i: Int = randomlist.firstIndex(of: soundLoaded) ?? 0

            if goTo > 0 {
                soundLoaded = soundLoaded == randomlist[randomlist.count - 1] ? randomlist[0] : randomlist[i + goTo]
            } else {
                soundLoaded = soundLoaded == randomlist[0] ? randomlist[randomlist.count - 1] : randomlist[i + goTo]
                
            }
        
        } else {
            if goTo > 0 {
                soundLoaded = soundLoaded == maxSound ? minSound : soundLoaded + goTo
            } else {
                soundLoaded = soundLoaded == minSound ? maxSound : soundLoaded + goTo
            }
            
        }
        print(soundLoaded)
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
        print(randomlist)
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
        nextOrBackSound(-1)
    }
    
    //  Acción para pasar a la siguiente canción
    @IBAction func forwardControl(_ sender: UIButton) {
        nextOrBackSound(1)
    }
    
    //  Acción para poner la lista a reproducir en modo shuffle
    @IBAction func shuffleButtonControl(_ sender: UIButton) {
        shuffleSong.toggle()
        if shuffleSong {
            shuffleControl.tintColor = .green
            randomlist.removeAll()
            generateRandom()
            soundLoaded = randomlist[0]
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
            repeatControl.setImage(UIImage(systemName: "repeat.1"), for: .normal)
        } else {
            repeatControl.tintColor = .gray
            repeatControl.setImage(UIImage(systemName: "repeat"), for: .normal)
        }
        
    }
    
    //Funciones para resolver la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !shuffleSong ? playList.count : randomlist.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell

        var title: String = ""
        var artist: String = ""
        var color: UIColor = UIColor.white
        var hidden: Bool = true
        var image: UIImage = UIImage()
//        if shuffleSong {
//            title = playList[randomlist[indexPath.row]].title
//            artist = playList[randomlist[indexPath.row]].artist
//            hidden =  soundLoaded == randomlist[indexPath.row] ? false : true
//            color = soundLoaded == randomlist[indexPath.row] ? .green : .white
//        } else {
            title = playList[indexPath.row].title
            artist = playList[indexPath.row].artist
            hidden = soundLoaded == indexPath.row ? false : true
            color = soundLoaded == indexPath.row ? .green : .white
        image = playList[indexPath.row].image
        //}
        //speaker.wave.2
        cell.titleCell.text = " \(title)"
        cell.authorCell.text = "   - \(artist)"
        cell.iconSound.isHidden = hidden
        cell.titleCell.textColor = color
        cell.imageSound.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Celda \(indexPath.row) seleccionada")
        soundLoaded = indexPath.row
        initPlayer()
        playPause(true)
    }
    
    func callPressed(name: String) {
        print("Algo")
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

