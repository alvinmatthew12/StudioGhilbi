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
    
    func testGetMoviesWithInvalidUrlRequestErrorReturnsError() {
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

}
