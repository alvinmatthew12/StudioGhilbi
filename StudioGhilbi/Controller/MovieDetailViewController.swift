//
//  MovieDetailViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 02/04/21.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let movieModel = MovieModel()
    var movieId: String?
    var color: UIColor = .random
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovie()
    }
    
    func loadMovie() {
        guard let id = movieId else {
            self.navigationController?.popViewController(animated: true)
            self.showAlert(message: "Undifined movie id")
            return
        }
        movieModel.getMovieById(id).subscribe(onNext: { (movie) in
            DispatchQueue.main.async { [self] in
                yearLabel.text = movie.releaseDate
                titleLabel.text = movie.title
                directorLabel.text = movie.director
                descriptionLabel.text = movie.description
                coverView.backgroundColor = color
            }
        }, onError: { (error) in
            DispatchQueue.main.async {
                self.showAlert(message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
}
