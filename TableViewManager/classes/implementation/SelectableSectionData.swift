//
//  SelectableSectionData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/19.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public class SelectableSectionData: SectionData {
    public var didUpdateSelectedState: (() -> Void)?

    public override  required init(headerView: UIView? = nil,
                                   headerData: SectionHeaderData? = nil,
                                   rowDataList: [RowData],
                                   footerView: UIView? = nil,
                                   footerData: SectionFooterData? = nil) {
        var selectableRowDataList: [SelectableRowData] = []
        for rowData in rowDataList {
            if let rowData = rowData as? SelectableRowData {
                selectableRowDataList.append(rowData)
            }
        }

        super.init(headerView: headerView, headerData: headerData, rowDataList: selectableRowDataList, footerView: footerView, footerData: footerData)

        for selectableRowData in self.rowDataList as? [SelectableRowData] ?? [] {
            selectableRowData.didUpdateSelectedState = {[weak self] in
                self?.didUpdateSelectedState?()
            }
        }
    }

    public func selectedRowDataList() -> [SelectableRowData] {
        var selectedRowDataList: [SelectableRowData] = []

        for rowData in rowDataList {
            if let rowData = rowData as? SelectableRowData, rowData.isSelected() {
                selectedRowDataList.append(rowData)
            }
        }
        
        return selectedRowDataList
    }
}
