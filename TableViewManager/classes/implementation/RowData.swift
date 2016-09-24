//
//  RowData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

open class RowData: NSObject {
    open override func isEqual(_ object: Any?) -> Bool {
        return false
    }
}

public protocol RowDataAcceptableType {
    func update(_ rowData: RowData)
}
