//
//  ViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 31/03/21.
//

import UIKit
import RxSwift

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate {
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var movieModel = MovieModel()
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    var movieColors: [UIColor] = []
    var headerTitle = "Movies"
    var year: String = ""
    var minYear: String = ""
    var maxYear: String = ""
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryAgainButton.layer.cornerRadius = 10
        activityIndicator.hidesWhenStopped = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        loadMovieList()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "listToFilter", sender: self)
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: Any) {
        loadMovieList()
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityView.isHidden = false
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityView.isHidden = true
    }
    
    // MARK: - Manipulate Movie Data
    
    func loadMovieList() {
        errorView.isHidden = true
        showActivityIndicator()
        movieModel.getMovies().subscribe(onNext: { (movies) in
            DispatchQueue.main.async {
                self.allMovies = movies
                self.movies = movies
                self.setupMovieColors()
                self.hideActivityIndicator()
                self.tableView.reloadData()
            }
        }, onError: { (error) in
            DispatchQueue.main.async {
                self.showAlert(message: error.localizedDescription)
                self.errorView.isHidden = false
                self.hideActivityIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func setupMovieColors() {
        movieColors = []
        movies.forEach { _ in movieColors.append(.random) }
    }
    
    // MARK: - Filter
    
    func didUpdateFilter(_ filters: [String: [String]]?) {
        if let safeFilters = filters {
            if let yearRangeFilter = safeFilters["yearRange"] {
                year = ""
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
                minYear = ""
                maxYear = ""
                year = yearFilter[0]
                headerTitle = "Movies in \(year)"
                movies = movieModel.filterMovieByYear(allMovies, year)
            }
        } else {
            year = ""
            minYear = ""
            maxYear = ""
            headerTitle = "Movies"
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
            cell.thumbnailView.backgroundColor = movieColors[row]
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
                    vc.color = movieColors[row]
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
                    if availableYears.filter({ $0 == movie.releaseDate }).count < 1 {
                        availableYears.append(movie.releaseDate)
                    }
                }
                vc.availableYears = availableYears.sorted().reversed()
                vc.maxYearRange = allMovies.map { (Int($0.releaseDate) ?? 0) }.max() ?? 0
                vc.minYearRange = allMovies.map { Int($0.releaseDate) ?? 0 }.min() ?? 0
            }
        }
    }
}

