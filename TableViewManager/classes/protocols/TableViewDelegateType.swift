//
//  TableViewDelegateType.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDelegateType: UITableViewDelegate {
    var didSelectRow: ((IndexPath) -> Void)? { get set }
    var didDeselectRow: ((IndexPath) -> Void)? { get set }
}
