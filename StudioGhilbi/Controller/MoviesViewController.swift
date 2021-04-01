//
//  ViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 31/03/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let movies: [Movie] = [
        Movie(id: "1", title: "Castle in the Sky", director: "Hayao Miyazaki", releaseDate: "1986", description: ""),
        Movie(id: "2", title: "Grave of the Fireflies", director: "Isao Takahata", releaseDate: "1988", description: ""),
        Movie(id: "3", title: "My Neighbor Totoro", director: "Hayao Miyazaki", releaseDate: "1988", description: ""),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }

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
}

