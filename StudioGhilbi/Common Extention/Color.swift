//
//  Color.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 01/04/21.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
