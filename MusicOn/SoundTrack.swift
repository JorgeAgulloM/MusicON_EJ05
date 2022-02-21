//
//  File.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 20/2/22.
//

import Foundation
import AVKit

class SoundTrack {
    var rawName: String
    var url: String!
    var typeOf: String!
    var title: String!
    var artist: String!
    var image: UIImage!
    
    init(rawName: String) {
        self.rawName = rawName
        getInfoTrack()
    }
    
    func getInfoTrack() {
        self.url = String(rawName.dropLast(4))
        self.typeOf = String(rawName.dropFirst(rawName.count - 3))
        self.title = addNameSoundtrack()
        getMetaData()
    }
    
    func addNameSoundtrack() -> String{
        var title: String = ""
        for l in url{
            if l.isLetter { //Si es una letra
                if title == "" { //y name está vacio
                    title.append(l) //Se carga la letra
                } else { //si no está vacio
                    if l.isUppercase { //Si es una letra mayuscula
                        title.append(" \(l)") //Se inserta un espacio delante
                    } else { //Si no es mayuscula
                        title.append(l) //Se inserta sin más
                    }
                }
            } else {
                if l == "(" || l == ")" {
                    title.append(" \(l)")
                } else {
                    title.append("\(l)")
                }
            }
        }
        return title
    }
    
    func getMetaData () {
        let url = Bundle.main.url(forResource: self.url, withExtension: self.typeOf)!
        let song = AVAsset(url: url)
        
        song.metadata.forEach { meta in
            switch(meta.commonKey?.rawValue){
            case "artist": self.artist = meta.value as? String ?? "desconocido"
            case "artwork": if meta.value != nil{
                self.image = UIImage(data: meta.value as! Data)}
            default: ()
            }
        }
    }
}
