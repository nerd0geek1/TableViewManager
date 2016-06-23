//
//  SectionData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public class SectionData {
    private let rowDataList: [RowData]

    //MARK: - public

    public init(rowDataList: [RowData]) {
        self.rowDataList = rowDataList
    }

    public func numberOfRows() -> Int {
        return rowDataList.count
    }

    public func rowData(at index: Int) -> RowData? {
        if index >= numberOfRows() {
            return nil
        }

        return rowDataList[index]
    }
}
