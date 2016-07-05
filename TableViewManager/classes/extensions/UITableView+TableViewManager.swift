//
//  UITableView+TableViewManager.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 7/5/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import UIKit

public extension UITableView {
    public func setup(dataSource dataSource: TableViewDataSource, delegate: TableViewDelegate) {
        delegate.dataSource = dataSource

        self.dataSource = dataSource
        self.delegate   = delegate
    }
}
