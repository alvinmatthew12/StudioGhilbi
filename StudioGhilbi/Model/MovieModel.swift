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
                    if error != nil {
                        observer.onError(error!)
                    } else {
                        let jsonData = try JSONDecoder().decode([Movie].self, from: data ?? Data())
                        observer.onNext(jsonData)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func setupMovieList() {
        getMovies().subscribe(onNext: { (movies) in
            self.delegate?.didUpdateMovies(self, movies: movies)
        }, onError: { (error) in
            self.delegate?.didFailWithError(error: error, errorMessage: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func filterMovieByYear(_ movies: [Movie], _ year: String) -> [Movie] {
        return movies.filter { $0.releaseDate == year }
    }
    
    func filterMovieByYear(_ movies: [Movie], minYear: String, maxYear: String) -> [Movie] {
        if minYear != "" && maxYear != "" {
            return movies.filter { Int($0.releaseDate)! >= Int(minYear)! && Int($0.releaseDate)! <= Int(maxYear)! }
        } else if maxYear != "" {
            return movies.filter { Int($0.releaseDate)! <= Int(maxYear)! }
        } else if minYear != "" {
            return movies.filter { Int($0.releaseDate)! >= Int(minYear)! }
        }
        return []
    }
    
}
