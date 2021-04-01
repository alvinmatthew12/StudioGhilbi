//
//  Color.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 01/04/21.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
