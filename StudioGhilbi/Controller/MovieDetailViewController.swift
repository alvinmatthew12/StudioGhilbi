//
//  MovieDetailViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 02/04/21.
//

import UIKit
import RxSwift

class MovieDetailViewController: BaseViewController {

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
    
    override func errorTryAgainAction() {
        loadMovie()
    }
    
    func loadMovie() {
        self.activityIndicatorBegin()
        guard let id = movieId else {
            self.navigationController?.popViewController(animated: true)
            self.showAlert(title: "Undefined Movie", message: "Sorry something went wrong.")
            return
        }
        movieModel.getMovieById(id).subscribe(onNext: { (movie) in
            DispatchQueue.main.async { [self] in
                yearLabel.text = movie.releaseDate
                titleLabel.text = movie.title
                directorLabel.text = movie.director
                descriptionLabel.text = movie.description
                coverView.backgroundColor = color
                activityIndicatorEnd()
            }
        }, onError: { (error) in
            DispatchQueue.main.async { [self] in
                showAlert(message: error.localizedDescription)
                showErrorView(message: "Unable to load movie detail")
                activityIndicatorEnd()
            }
        }).disposed(by: disposeBag)
    }
}
