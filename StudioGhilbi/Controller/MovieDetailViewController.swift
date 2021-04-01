//
//  MovieDetailViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 02/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeMovie = movie {
            yearLabel.text = safeMovie.releaseDate
            titleLabel.text = safeMovie.title
            directorLabel.text = "Directed by \(safeMovie.director)"
            descriptionLabel.text = safeMovie.description
        }
    }
}
