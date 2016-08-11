//
//  SelectableSectionDataSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/19.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

class SelectableSectionDataSpec: QuickSpec {
    override func spec() {
        describe("SelectableSectionData") {
            describe("didUpdateSelectedState: (() -> Void)?", {
                let selectableRowDataList: [MockSelectableRowData] = [Int](0..<9).map({ MockSelectableRowData.init(index: $0) })
                let sectionData: SelectableSectionData             = SelectableSectionData(rowDataList: selectableRowDataList)
                var calledCount: Int                               = 0

                sectionData.didUpdateSelectedState = {
                    calledCount += 1

                    expect(sectionData.selectedRowDataList().count).to(equal(calledCount))
                }

                (sectionData.rowData(at: 0) as! MockSelectableRowData).toggleSelectedState()
                (sectionData.rowData(at: 2) as! MockSelectableRowData).toggleSelectedState()

            })
            describe("selectedRowDataList()", {
                let selectableRowDataList: [MockSelectableRowData] = [Int](0..<9).map({ MockSelectableRowData.init(index: $0) })
                let sectionData: SelectableSectionData             = SelectableSectionData(rowDataList: selectableRowDataList)

                (sectionData.rowData(at: 0) as! MockSelectableRowData).toggleSelectedState()
                (sectionData.rowData(at: 3) as! MockSelectableRowData).toggleSelectedState()
                (sectionData.rowData(at: 5) as! MockSelectableRowData).toggleSelectedState()

                let selectedRowDataList: [MockSelectableRowData] = sectionData.selectedRowDataList() as! [MockSelectableRowData]

                expect(selectedRowDataList.count).to(equal(3))
                expect(selectedRowDataList[0].index).to(equal(0))
                expect(selectedRowDataList[1].index).to(equal(3))
                expect(selectedRowDataList[2].index).to(equal(5))
            })
        }
    }

    private class MockSelectableRowData: SelectableRowData {
        let index: Int

        init(index: Int) {
            self.index = index
        }
    }
}
