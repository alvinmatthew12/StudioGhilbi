//
//  MovieModel.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 01/04/21.
//

import Foundation
import RxSwift

protocol MovieModelDelegate {
    func didUpdateMovies(_ model: MovieModel, movies: [Movie])
    func didFailWithError(error: Error, errorMessage: String)
}

class MovieModel {
    
    private let disposeBag = DisposeBag()
    var delegate: MovieModelDelegate?
    
    private func getMovies() -> Observable<[Movie]> {
        let urlRequest = URLRequest(url:  URL(string: "https://ghibliapi.herokuapp.com/films")!)
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
                do {
                    let jsonData = try JSONDecoder().decode([Movie].self, from: data!)
                    observer.onNext(jsonData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create()
        }
    }
    
    func setupMovieList() {
        getMovies().subscribe(onNext: { (movies) in
            self.delegate?.didUpdateMovies(self, movies: movies)
        }, onError: { (error) in
            self.delegate?.didFailWithError(error: error, errorMessage: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
}
