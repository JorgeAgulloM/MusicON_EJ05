//
//  File.swift
//  MusicOn
//
//  Created by Jorge Agullo Martin on 20/2/22.
//

import Foundation

class SoundTrack {
    var url: String!
    var typeOf: String!
    var title: String!
    var artist: String!
    var image: String!
    
    init(url: String,
         typeOf: String,
         title: String,
         artist: String,
         image: String)
    {
        self.url = url
        self.typeOf = typeOf
        self.title = title
        self.artist = artist
        self.image = image
    }
    /**
     for l in 0..<self.url.count {
         
         let n: String.Index = self.url.index(self.url.startIndex, offsetBy: 1)
         self.title = self.title + self.url.substring(to: l)
     }
     
     /**
      let index: String.Index = str.index(str.startIndex, offsetBy: 4)
      var result: String = str.substring(to: index)
      */
     
     */
    
}
