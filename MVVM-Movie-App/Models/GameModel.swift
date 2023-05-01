//
//  GameModel.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 14.04.2023.
//

import Foundation
struct GameList: Decodable {
    let results: [Game]
}

// MARK: - Result
struct Game: Decodable {
    let id: Int
    let slug, name, released: String
    var description_raw :String?
    let background_image: String
    let rating: Double
    
}
