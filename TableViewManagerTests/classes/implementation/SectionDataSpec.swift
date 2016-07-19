//
//  SectionDataSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/04.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

class SectionDataSpec: QuickSpec {
    override func spec() {
        describe("SectionData") {
            describe("numberOfRows()", {
                context("when initialized with empty array", {
                    it("will return 0", closure: {
                        let sectionData: SectionData = SectionData(rowDataList: [])

                        expect(sectionData.numberOfRows()).to(equal(0))
                    })
                })
                context("when initialized with not empty array", {
                    it("will return passed array count", closure: {
                        let numberOfRows: Int        = 10
                        let rowDataList: [RowData]   = [Int](0..<numberOfRows).map({ _ in RowData() })
                        let sectionData: SectionData = SectionData(rowDataList: rowDataList)

                        expect(sectionData.numberOfRows()).to(equal(numberOfRows))
                    })
                })
            })
            describe("rowData(at index: Int)", {
                class DummyRowData: RowData {
                    let index: Int
                    let title: String

                    init(index: Int) {
                        self.index = index
                        self.title = "title\(index)"
                    }
                }

                context("with invalid index", {
                    it("will return nil", closure: {
                        let rowDataList: [DummyRowData] = [Int](0..<10).map({ DummyRowData.init(index: $0) })
                        let sectionData: SectionData    = SectionData(rowDataList: rowDataList)

                        expect(sectionData.rowData(at: -1)).to(beNil())
                        expect(sectionData.rowData(at: 10)).to(beNil())
                    })
                })
                context("with valid index", {
                    it("will return RowData at selected index", closure: {
                        let rowDataList: [DummyRowData] = [Int](0..<10).map({ DummyRowData.init(index: $0) })
                        let sectionData: SectionData    = SectionData(rowDataList: rowDataList)

                        let firstRowData: DummyRowData?  = sectionData.rowData(at: 0) as? DummyRowData
                        let middleRowData: DummyRowData? = sectionData.rowData(at: 4) as? DummyRowData
                        let lastRowData: DummyRowData?   = sectionData.rowData(at: 9) as? DummyRowData
                        expect(firstRowData).notTo(beNil())
                        expect(firstRowData!.index).to(equal(0))
                        expect(firstRowData!.title).to(equal("title0"))

                        expect(middleRowData).notTo(beNil())
                        expect(middleRowData!.index).to(equal(4))
                        expect(middleRowData!.title).to(equal("title4"))

                        expect(lastRowData).notTo(beNil())
                        expect(lastRowData!.index).to(equal(9))
                        expect(lastRowData!.title).to(equal("title9"))
                    })
                })
            })
        }
    }
}
