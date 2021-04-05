//
//  MovieAPICallTests.swift
//  StudioGhilbiTests
//
//  Created by Alvin Matthew Pratama on 05/04/21.
//

@testable import StudioGhilbi
import XCTest
import RxSwift

class MockMovieModel: MovieModel {
    
    override func getMovies() -> Observable<[Movie]> {
        let urlRequest = URLRequest(url:  URL(string: "\(baseUrl)\(defaultFieldParams)")!)
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
    
    override func getMovieById(_ id: String) -> Observable<Movie> {
        let urlRequest = URLRequest(url:  URL(string: "\(baseUrl)/\(id)\(defaultFieldParams)")!)
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
                do {
                    if error != nil {
                        observer.onError(error!)
                    } else {
                        let jsonData = try JSONDecoder().decode(Movie.self, from: data ?? Data())
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
}

class MockFakeMovieModel: MovieModel {
    override func getMovies() -> Observable<[Movie]> {
        let urlRequest = URLRequest(url:  URL(string: "https://ghibliapi.herokuapp.com/film")!)
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
    
    override func getMovieById(_ id: String) -> Observable<Movie> {
        let urlRequest = URLRequest(url:  URL(string: "https://ghibliapi.herokuapp.com/film/\(id)\(defaultFieldParams)")!)
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
                do {
                    if error != nil {
                        observer.onError(error!)
                    } else {
                        let jsonData = try JSONDecoder().decode(Movie.self, from: data ?? Data())
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
}


class MovieAPICallTests: XCTestCase {
    
    func testGetMoviesSuccessReturnMovies() {
        let disposeBag = DisposeBag()
        let mockMovieModel = MockMovieModel()
        let moviesExpectation = expectation(description: "movies")
        var moviesRes: [Movie]?
        
        mockMovieModel.getMovies().subscribe(onNext: { (movies) in
            moviesRes = movies
            moviesExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(moviesRes)
        }
    }
    
    func testGetMoviesWithInvalidUrlRequestErrorReturnError() {
        let disposeBag = DisposeBag()
        let mockFakeMovieModel = MockFakeMovieModel()
        let errorExpectation = expectation(description: "error")
        var errorRes: Error?
        
        mockFakeMovieModel.getMovies().subscribe(onNext: { (movies) in
            print(movies)
        }, onError: { (error) in
            errorRes = error
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(errorRes)
        }
    }
    
    func testGetMovieByIdSuccessReturnMovie() {
        let disposeBag = DisposeBag()
        let mockMovieModel = MockMovieModel()
        let movieExpectation = expectation(description: "movie")
        var movieRes: Movie?
        
        mockMovieModel.getMovieById("2baf70d1-42bb-4437-b551-e5fed5a87abe").subscribe(onNext: { (movie) in
            movieRes = movie
            movieExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(movieRes)
        }
    }
    
    func testGetMovieByIdWithInvalidIdErrorReturnError() {
        let disposeBag = DisposeBag()
        let mockMovieModel = MockMovieModel()
        let errorExpectation = expectation(description: "error")
        var errorRes: Error?
        
        mockMovieModel.getMovieById("1").subscribe(onNext: { (movie) in
            print(movie)
        }, onError: { (error) in
            errorRes = error
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(errorRes)
        }
    }
    
    func testGetMovieByIdWithInvalidUrlRequestErrorReturnError() {
        let disposeBag = DisposeBag()
        let mockFakeMovieModel = MockFakeMovieModel()
        let errorExpectation = expectation(description: "error")
        var errorRes: Error?
        
        mockFakeMovieModel.getMovieById("2baf70d1-42bb-4437-b551-e5fed5a87abe").subscribe(onNext: { (movie) in
            print(movie)
        }, onError: { (error) in
            errorRes = error
            errorExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(errorRes)
        }
    }
    
}
