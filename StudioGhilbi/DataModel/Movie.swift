//
//  Movie.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 01/04/21.
//

import Foundation

class Movie {
    let id: String
    let title: String
    let director: String
    let releaseDate: String
    let description: String
    
    init(id: String, title: String, director: String, releaseDate: String, description: String) {
        self.id = id
        self.title = title
        self.director = director
        self.releaseDate = releaseDate
        self.description = description
    }
}
