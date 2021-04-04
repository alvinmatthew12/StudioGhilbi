//
//  ViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 31/03/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieModelDelegate, FilterViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let movieModel = MovieModel()
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    var headerTitle = "Movies"
    var year: String = ""
    var minYear: String = ""
    var maxYear: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        movieModel.delegate = self
        movieModel.setupMovieList()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "listToFilter", sender: self)
    }
    
    // MARK: - Manipulate Movie Data
    
    func didUpdateMovies(_ model: MovieModel, movies: [Movie]) {
        DispatchQueue.main.async {
            self.allMovies = movies
            self.movies = movies
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        self.showAlert(message: errorMessage)
    }
    
    // MARK: - Filter
    
    func didUpdateFilter(_ filters: [String: [String]]?) {
        if let safeFilters = filters {
            if let yearRangeFilter = safeFilters["yearRange"] {
                minYear = yearRangeFilter[0]
                maxYear = yearRangeFilter[1]
                if minYear != "" && maxYear != "" {
                    headerTitle = "Movies from \(minYear) to \(maxYear)"
                } else if minYear != "" {
                    headerTitle = "Filter by Min Year \(minYear)"
                } else if maxYear != "" {
                    headerTitle = "Filter by Max Year \(maxYear)"
                }
                movies = movieModel.filterMovieByYear(allMovies, minYear: minYear, maxYear: maxYear)
            } else if let yearFilter = safeFilters["year"] {
                year = yearFilter[0]
                headerTitle = "Movies in \(year)"
                movies = movieModel.filterMovieByYear(allMovies, year)
            }
        } else {
            movies = allMovies
        }
        tableView.reloadData()
    }
    
    
    // MARK:- TableView DataSource, Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = headerTitle
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            return cell
        }
        if indexPath.row > 0 {
            let row = indexPath.row - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.thumbnailView.backgroundColor = .random
            cell.titleLabel.text = movies[row].title
            cell.directorLabel.text = movies[row].director
            cell.yearLabel.text = movies[row].releaseDate
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            performSegue(withIdentifier: "listToDetail", sender: self)
        }
    }
    
    // MARK:- Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "listToDetail") {
            if let vc = segue.destination as? MovieDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let row = indexPath.row - 1
                    vc.movie = movies[row]
                }
            }
        }
        if(segue.identifier == "listToFilter") {
            if let vc = segue.destination as? FilterViewController {
                vc.delegate = self
                vc.selectedYear = year
                vc.selectedMinYear = minYear
                vc.selectedMaxYear = maxYear
                var availableYears: [String] = []
                for movie in allMovies {
                    availableYears.append(movie.releaseDate)
                }
                vc.availableYears = availableYears.sorted().reversed()
                vc.maxYearRange = allMovies.map { (Int($0.releaseDate) ?? 0) }.max() ?? 0
                vc.minYearRange = allMovies.map { Int($0.releaseDate) ?? 0 }.min() ?? 0
            }
        }
    }
}

