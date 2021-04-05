//
//  BaseViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 06/04/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    var activityView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var errorView: UIView = UIView()
    var errorLabel: UILabel = UILabel()
    var tryAgainButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func activityIndicatorBegin() {
        activityView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        activityView.backgroundColor = UIColor.systemBackground
        self.view.addSubview(activityView)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorEnd() {
        activityIndicator.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func showErrorView(message: String) {
        
        if errorView.isDescendant(of: self.view) {
            errorView.removeFromSuperview()
        }
        
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        errorView.backgroundColor = UIColor.systemBackground
        self.view.addSubview(errorView)
        
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.backgroundColor = UIColor.link
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        errorView.addSubview(tryAgainButton)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 110).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tryAgainButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        tryAgainButton.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        
        errorLabel.textColor = UIColor.label
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.textAlignment = .center
        errorLabel.text = message
        errorView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 20).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -20).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: tryAgainButton.topAnchor, constant: -30).isActive = true
    }
    
    @objc func tryAgainButtonPressed(sender: UIButton!) {
        errorView.removeFromSuperview()
        errorTryAgainAction()
    }
    
    func errorTryAgainAction() {
        // override to do something
    }

}
