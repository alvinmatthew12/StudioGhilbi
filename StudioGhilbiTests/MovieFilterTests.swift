//
//  MovieFilterTests.swift
//  StudioGhilbiTests
//
//  Created by Alvin Matthew Pratama on 03/04/21.
//

@testable import StudioGhilbi
import XCTest

class MovieFilterTests: XCTestCase {
    
    var movieModel: MovieModel!
    
    let movies: [Movie] = [
        Movie(id: "1", title: "Stranger Things 4", director: "Duffer Brothers", releaseDate: "2021", description: ""),
        Movie(id: "2", title: "One Piece", director: "Eichiro Oda", releaseDate: "2015", description: ""),
        Movie(id: "3", title: "Attack on Titan", director: "Hajime Isayama", releaseDate: "2018", description: ""),
        Movie(id: "4", title: "Dota Dragon's Blood", director: "Park So Young, Kim Eui Jeong", releaseDate: "2019", description: ""),
        Movie(id: "5", title: "Sherlock Holmes", director: "Guy Ritchie", releaseDate: "2017", description: ""),
    ]
    
    override func setUp() {
        super.setUp()
        movieModel = MovieModel()
    }
    
    override func tearDown() {
        super.tearDown()
        movieModel = nil
    }
    
    func testFilterYear() {
        let filtered = movieModel.filterMovieByYear(movies, "2015")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered[0].title, "One Piece")
        XCTAssertEqual(filtered[0].id, "2")
    }
    
    func testFilterMinYear() {
        let filtered = movieModel.filterMovieByYear(movies, minYear: "2018", maxYear: "")
        XCTAssertEqual(filtered.count, 3)
        let foundAoT = filtered.filter { $0.title == "Attack on Titan" }
        XCTAssertEqual(foundAoT.count, 1)
        XCTAssertEqual(foundAoT[0].title, "Attack on Titan")
        let foundOP = filtered.filter { $0.title == "One Piece" }
        XCTAssertNotEqual(foundOP.count, 1)
    }
    
    func testFilterMaxYear() {
        let filtered = movieModel.filterMovieByYear(movies, minYear: "", maxYear: "2017")
        XCTAssertEqual(filtered.count, 2)
        let foundAoT = filtered.filter { $0.title == "Attack on Titan" }
        XCTAssertNotEqual(foundAoT.count, 1)
        let foundOP = filtered.filter { $0.title == "One Piece" }
        XCTAssertEqual(foundOP.count, 1)
        XCTAssertEqual(foundOP[0].title, "One Piece")
    }
    
    func testFilterYearRange() {
        let filtered = movieModel.filterMovieByYear(movies, minYear: "2016", maxYear: "2020")
        XCTAssertEqual(filtered.count, 3)
        let foundAoT = filtered.filter { $0.title == "Attack on Titan" }
        XCTAssertEqual(foundAoT.count, 1)
        XCTAssertEqual(foundAoT[0].title, "Attack on Titan")
        let foundOP = filtered.filter { $0.title == "One Piece" }
        XCTAssertNotEqual(foundOP.count, 1)
        let foundST = filtered.filter { $0.title.contains("Stranger Things") }
        XCTAssertNotEqual(foundST.count, 1)
    }
}
