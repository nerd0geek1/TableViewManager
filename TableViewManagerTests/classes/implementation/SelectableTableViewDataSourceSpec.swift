//
//  SelectableTableViewDataSourceSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/21.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble
import Result

class SelectableTableViewDataSourceSpec: QuickSpec {
    override func spec() {
        describe("SelectableTableViewDataSource") {
            describe("didUpdateSelectedState: (() -> Void)?") {
                it("will be called when rowData selectedState is updated", closure: {
                    let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                    var calledCount: Int = 0

                    tableViewAndRelatedModules.dataSource.didUpdateSelectedState = {
                        calledCount += 1
                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(equal(calledCount % 2 == 0))
                    }

                    (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                    (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 0)) as! SelectableRowData).setSelectedState(false)

                    expect(calledCount == 0).toEventually(beFalse())
                })
            }
            describe("selectedRowDataList()") {
                context("without any cells are selected state", {
                    it("will return empty array", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(beTrue())
                    })
                })
                context("with some cells are selected state", {
                    it("will return empty array", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()
                        let indexPath1: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let indexPath2: NSIndexPath = NSIndexPath(forRow: 2, inSection: 1)

                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath1) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath2) as! SelectableRowData).setSelectedState(true)

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().count).to(equal(2))
                        expect((tableViewAndRelatedModules.dataSource.selectedRowDataList()[0] as! DummySelectableRowData).indexPath).to(equal(indexPath1))
                        expect((tableViewAndRelatedModules.dataSource.selectedRowDataList()[1] as! DummySelectableRowData).indexPath).to(equal(indexPath2))
                    })
                })
            }
            describe("toggleAllRowDataSelectedState()") {
                context("with rowDataList which consist of selected rowData", {
                    it("will make all rowData not selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 1, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 2, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 1)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 1, inSection: 1)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 2, inSection: 1)) as! SelectableRowData).setSelectedState(true)

                        tableViewAndRelatedModules.dataSource.makeSameOrToggleAllRowDataSelectedState()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(beTrue())
                    })
                })
                context("with rowDataList which consist of selected/not selected rowData", {
                    it("will make all rowData selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()
                        let indexPath1: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let indexPath2: NSIndexPath = NSIndexPath(forRow: 1, inSection: 1)

                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath1) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath2) as! SelectableRowData).setSelectedState(true)

                        tableViewAndRelatedModules.dataSource.makeSameOrToggleAllRowDataSelectedState()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().count).to(equal(6))
                    })
                })
                context("with rowDataList which consist of not selected rowData", {
                    it("will make all rowData selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.dataSource.makeSameOrToggleAllRowDataSelectedState()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().count).to(equal(6))
                    })
                })
            }
            describe("clearAllRowDataSelectedState()") {
                context("with rowDataList which consist of selected rowData", {
                    it("will make all rowData not selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 1, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 2, inSection: 0)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 0, inSection: 1)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 1, inSection: 1)) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: NSIndexPath(forRow: 2, inSection: 1)) as! SelectableRowData).setSelectedState(true)

                        tableViewAndRelatedModules.dataSource.clearAllRowDataSelectedState()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(beTrue())
                    })
                })
                context("with rowDataList which consist of selected/not selected rowData", {
                    it("will make all rowData not selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()
                        let indexPath1: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let indexPath2: NSIndexPath = NSIndexPath(forRow: 1, inSection: 1)

                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath1) as! SelectableRowData).setSelectedState(true)
                        (tableViewAndRelatedModules.dataSource.rowData(at: indexPath2) as! SelectableRowData).setSelectedState(true)

                        tableViewAndRelatedModules.dataSource.clearAllRowDataSelectedState()

                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(beTrue())
                    })
                })
                context("with rowDataList which consist of not selected rowData", {
                    it("will make all rowData not selected", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.dataSource.clearAllRowDataSelectedState()
                        
                        expect(tableViewAndRelatedModules.dataSource.selectedRowDataList().isEmpty).to(beTrue())
                    })
                })
            }
        }
    }

    private func generateTableViewAndRelatedModules() -> (tableView: UITableView, dataSource: SelectableTableViewDataSource, sectionDataFactory: DummySectionDataFactory) {
        let cellClassResolver                           = TableViewSingleCellClassResolver<DummySelectableTableViewCell>.self
        let sectionDataFactory: DummySectionDataFactory = DummySectionDataFactory()
        sectionDataFactory.sectionCount = 2
        sectionDataFactory.rowDataCount = 3
        let dataSource: SelectableTableViewDataSource = SelectableTableViewDataSource(sectionDataFactory: sectionDataFactory, cellClassResolver: cellClassResolver)
        let tableView: UITableView                    = UITableView()
        tableView.dataSource = dataSource

        return (tableView: tableView, dataSource: dataSource, sectionDataFactory: sectionDataFactory)
    }
}

private class DummySelectableRowData: SelectableRowData {
    var indexPath: NSIndexPath
    var title: String

    init(indexPath: NSIndexPath) {
        self.indexPath = indexPath
        self.title = "dummy title \(indexPath.section)\(indexPath.row)"
    }

    override func isEqual(object: AnyObject?) -> Bool {
        guard let object = object as? DummySelectableRowData else {
            return false
        }

        return indexPath == object.indexPath
    }
}

private class DummySelectableTableViewCell: UITableViewCell, RowDataAcceptableType {
    private(set) var rowData: DummySelectableRowData?

    func update(rowData: RowData) {
        guard let rowData = rowData as? DummySelectableRowData else {
            return
        }

        self.rowData = rowData
    }
}

private class DummySectionDataFactory: SectionDataFactoryType {
    var sectionCount: Int = 0
    var rowDataCount: Int = 0

    private func create(for section: Int, completion: ((sectionData: SectionData, error: NSError?) -> Void)) {
        let rowDataList: [DummySelectableRowData] = [Int](0..<rowDataCount).map({
            DummySelectableRowData.init(indexPath: NSIndexPath(forRow: $0, inSection: section))
        })

        completion(sectionData: SelectableSectionData(rowDataList: rowDataList), error: nil)
    }

    func numberOfSections() -> Int {
        return sectionCount
    }
}
