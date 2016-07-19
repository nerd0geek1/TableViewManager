//
//  SelectableRowDataSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/19.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

class SelectableRowDataSpec: QuickSpec {
    override func spec() {
        describe("SelectableRowData") {
            describe("isSelected()", {
                it("will return current selected value", closure: {
                    let rowData: SelectableRowData = SelectableRowData()

                    expect(rowData.isSelected()).to(beFalse())
                })
            })
            describe("setSelectedState(isSelected: Bool)", {
                it("will update selected value", closure: {
                    let rowData: SelectableRowData = SelectableRowData()

                    rowData.setSelectedState(true)

                    expect(rowData.isSelected()).to(beTrue())

                    rowData.setSelectedState(false)

                    expect(rowData.isSelected()).to(beFalse())
                })
            })
            describe("toggleSelectedState()", {
                it("will reverse current selected value", closure: {
                    let rowData: SelectableRowData = SelectableRowData()

                    rowData.toggleSelectedState()

                    expect(rowData.isSelected()).to(beTrue())

                    rowData.toggleSelectedState()

                    expect(rowData.isSelected()).to(beFalse())
                })
            })
            describe("didUpdateSelectedState: (() -> Void)?", {
                it("", closure: {
                    let rowData: SelectableRowData = SelectableRowData()
                    var calledCount: Int           = 0

                    rowData.didUpdateSelectedState = {
                        calledCount += 1

                        let expectedState: Bool = !(calledCount % 2 == 0)
                        expect(rowData.isSelected()).to(equal(expectedState))
                    }

                    rowData.toggleSelectedState()
                    rowData.toggleSelectedState()
                })
            })
        }
    }
}
