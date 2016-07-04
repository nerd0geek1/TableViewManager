//
//  RowData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public class RowData: NSObject {
    public override func isEqual(object: AnyObject?) -> Bool {
        return false
    }
}

public protocol RowDataAcceptableType {
    func update(rowData: RowData)
}
