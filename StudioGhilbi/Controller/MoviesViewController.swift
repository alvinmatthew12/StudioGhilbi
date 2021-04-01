//
//  ViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 31/03/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let movieModel = MovieModel()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        movieModel.delegate = self
        movieModel.setupMovieList()
    }
    
    // MARK: - Manipulate Movie Data
    
    func didUpdateMovies(_ model: MovieModel, movies: [Movie]) {
        DispatchQueue.main.async {
            self.movies = movies
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        print(errorMessage)
    }
    
    
    // MARK:- TableView DataSource, Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.thumbnailView.backgroundColor = .random
        cell.titleLabel.text = movies[indexPath.row].title
        cell.directorLabel.text = movies[indexPath.row].director
        cell.yearLabel.text = movies[indexPath.row].releaseDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToDetail", sender: self)
    }
    
    // MARK:- Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "listToDetail") {
            if let vc = segue.destination as? MovieDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.movie = movies[indexPath.row]
                }
            }
        }
    }
}

