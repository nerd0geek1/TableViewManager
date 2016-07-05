//
//  TableViewDelegate.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public class TableViewDelegate: NSObject, TableViewDelegateType {
    public var didSelectRow: (NSIndexPath -> Void)?
    public var didDeselectRow: (NSIndexPath -> Void)?
    public weak var dataSource: TableViewDataSource?

    //MARK: - UITableViewDelegate

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        didSelectRow?(indexPath)
    }

    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        didDeselectRow?(indexPath)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let cell = tableView.cellForRowAtIndexPath(indexPath), customizedHeightCell = cell as? CustomizedCellHeightType {
            return customizedHeightCell.dynamicType.customizedHeight
        }

        return 44
    }
}
