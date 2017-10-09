//
//  UITableViewCell+Addition.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 10/9/17.
//  Copyright © 2017 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String.className(of: self)
    }
}
