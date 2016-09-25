//
//  SelectableTableViewDataSource.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/19.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public class SelectableTableViewDataSource: TableViewDataSource {
    public var didUpdateSelectedState: (() -> Void)?

    override func didUpdateSectionDataList() {
        for sectionData in sectionDataList {
            if let sectionData = sectionData as? SelectableSectionData {
                sectionData.didUpdateSelectedState = { [weak self] () -> Void in
                    self?.didUpdateSelectedState?()
                }
            }
        }
    }

    public func selectedRowDataList() -> [SelectableRowData] {
        var allSelectedRowDataList: [SelectableRowData] = []

        if let sectionDataList = sectionDataList as? [SelectableSectionData] {
            for sectionData in sectionDataList {
                allSelectedRowDataList.append(contentsOf: sectionData.selectedRowDataList())
            }
        }

        return allSelectedRowDataList
    }

    public func makeSameOrToggleAllRowDataSelectedState() {
        guard let allRowDataList: [SelectableRowData] = self.allRowDataList() as? [SelectableRowData] else {
            return
        }

        let selectedState: Bool = allRowDataList.count == 0 || allRowDataList.count != selectedRowDataList().count
        for rowData in allRowDataList {
            rowData.setSelectedState(selectedState)
        }
    }

    public func clearAllRowDataSelectedState() {
        guard let allRowDataList: [SelectableRowData] = self.allRowDataList() as? [SelectableRowData] else {
            return
        }

        for rowData in allRowDataList {
            rowData.setSelectedState(false)
        }
    }
}
