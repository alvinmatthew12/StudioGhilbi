//
//  ViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 04/04/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Error", message: String, actionTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
