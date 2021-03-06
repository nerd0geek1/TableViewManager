//
//  SectionData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public class SectionData {
    public let headerView: UIView?
    public let headerData: SectionHeaderData?
    let rowDataList: [RowData]
    public let footerView: UIView?
    public let footerData: SectionFooterData?

    // MARK: - public

    public required init(headerView: UIView? = nil,
                         headerData: SectionHeaderData? = nil,
                         rowDataList: [RowData],
                         footerView: UIView? = nil,
                         footerData: SectionFooterData? = nil) {
        self.headerView  = headerView
        self.headerData  = headerData
        self.rowDataList = rowDataList
        self.footerView  = footerView
        self.footerData  = footerData
    }

    public func numberOfRows() -> Int {
        return rowDataList.count
    }

    public func rowData(at index: Int) -> RowData? {
        if index < 0 || index >= numberOfRows() {
            return nil
        }

        return rowDataList[index]
    }
}

public class SectionHeaderData {
    public let headerHeight: CGFloat

    public init(height: CGFloat) {
        self.headerHeight = height
    }
}

public class SectionFooterData {
    public let footerHeight: CGFloat

    public init(height: CGFloat) {
        self.footerHeight = height
    }
}

public protocol SectionHeaderDataAcceptableType {
    func update(_ headerData: SectionHeaderData)
}

public protocol SectionFooterDataAcceptableType {
    func update(_ footerData: SectionFooterData)
}
