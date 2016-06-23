//
//  RowData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public func ==(lhs: RowData, rhs: RowData) -> Bool {
    return false
}

public class RowData: Equatable {}

public protocol RowDataAcceptableType {
    func update(rowData: RowData)
}
