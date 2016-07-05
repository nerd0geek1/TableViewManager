//
//  TableViewCellClassResolverType.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewCellClassResolverType {
    static func registeredCellClasses() -> [UITableViewCell.Type]
    static func cellClass(for indexPath: NSIndexPath) -> UITableViewCell.Type
}

public class TableViewSingleCellClassResolver<T: UITableViewCell>: TableViewCellClassResolverType {
    public static func registeredCellClasses() -> [UITableViewCell.Type] {
        return [T.self]
    }

    public static func cellClass(for indexPath: NSIndexPath) -> UITableViewCell.Type {
        return T.self
    }
}
