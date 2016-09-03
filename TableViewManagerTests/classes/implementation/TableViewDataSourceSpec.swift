//
//  TableViewDataSourceSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/04.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble
import Result

class TableViewDataSourceSpec: QuickSpec {
    override func spec() {
        describe("TableViewDataSource") {
            describe("sectionCount()", {
                it("return section count", closure: {
                    let tableViewAndRelatedModules                  = self.generateTableViewAndRelatedModules()
                    let sectionDataFactory: DummySectionDataFactory = tableViewAndRelatedModules.sectionDataFactory
                    let dataSource: TableViewDataSource             = tableViewAndRelatedModules.dataSource

                    expect(tableViewAndRelatedModules.dataSource.sectionCount()).to(equal(2))

                    sectionDataFactory.sectionCount = 5
                    dataSource.updateSectionDataList({ result in
                        expect(dataSource.sectionCount()).to(equal(5))
                    })
                })
            })
            describe("allRowDataList()", {
                it("will return RowData array in order of section sorted", closure: {
                    let tableViewAndRelatedModules                  = self.generateTableViewAndRelatedModules()
                    let sectionDataFactory: DummySectionDataFactory = tableViewAndRelatedModules.sectionDataFactory
                    let dataSource: TableViewDataSource             = tableViewAndRelatedModules.dataSource

                    let rowDataList: [RowData] = dataSource.allRowDataList()

                    expect(rowDataList.count).to(equal(6))
                    expect((rowDataList[0] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 0, inSection: 0)))
                    expect((rowDataList[2] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 2, inSection: 0)))
                    expect((rowDataList[3] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 0, inSection: 1)))

                    sectionDataFactory.sectionCount = 3
                    sectionDataFactory.rowDataCount = 4

                    dataSource.updateSectionDataList({ result in
                        let rowDataList: [RowData] = dataSource.allRowDataList()

                        expect(rowDataList.count).to(equal(12))
                        expect((rowDataList[0] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 0, inSection: 0)))
                        expect((rowDataList[3] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 3, inSection: 0)))
                        expect((rowDataList[4] as! DummyRowData).indexPath).to(equal(NSIndexPath(forRow: 0, inSection: 1)))
                    })
                })
            })
            describe("rowData(at indexPath: NSIndexPath)", {
                context("with valid indexPath", {
                    it("return valid DummyRowData", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        let indexPath: NSIndexPath          = NSIndexPath(forRow: 1, inSection: 1)
                        let dataSource: TableViewDataSource = tableViewAndRelatedModules.dataSource

                        let rowData: DummyRowData? = dataSource.rowData(at: indexPath) as? DummyRowData

                        expect(rowData).notTo(beNil())
                        expect(rowData?.indexPath).to(equal(indexPath))
                        expect(rowData?.title).to(equal("dummy title 11"))
                    })
                })
                context("with invalid indexPath", {
                    it("will return nil", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        let indexPath: NSIndexPath          = NSIndexPath(forRow: 1, inSection: 2)
                        let dataSource: TableViewDataSource = tableViewAndRelatedModules.dataSource

                        let rowData: DummyRowData? = dataSource.rowData(at: indexPath) as? DummyRowData

                        expect(rowData).to(beNil())
                    })
                })
            })

            describe("updateSectionDataList(completion: ((insertedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath]) -> Void)?)", {
                context("when some UITableViewCells are inserted", {
                    it("will return not empty insertedIndexPaths, empty removedIndexPaths", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.sectionDataFactory.sectionCount = 3

                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ result in
                            switch result {
                            case .Success(let insertedIndexPaths, let removedIndexPaths):
                                expect(insertedIndexPaths.count).to(equal(3))
                                expect(removedIndexPaths.count).to(equal(0))

                                expect(insertedIndexPaths[0]).to(equal(NSIndexPath(forRow: 0, inSection: 2)))
                                expect(insertedIndexPaths[1]).to(equal(NSIndexPath(forRow: 1, inSection: 2)))
                                expect(insertedIndexPaths[2]).to(equal(NSIndexPath(forRow: 2, inSection: 2)))
                            case .Failure:  fail("SectionDataFactoryType return error unexpectedly.")
                            }
                        })
                    })
                })
                context("when some UITableViewCells are removed", {
                    it("will return empty insertedIndexPaths, empty removedIndexPaths", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.sectionDataFactory.rowDataCount = 2

                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ result in
                            switch result {
                            case .Success(let insertedIndexPaths, let removedIndexPaths):
                                expect(insertedIndexPaths.count).to(equal(0))
                                expect(removedIndexPaths.count).to(equal(2))

                                expect(removedIndexPaths[0]).to(equal(NSIndexPath(forRow: 2, inSection: 0)))
                                expect(removedIndexPaths[1]).to(equal(NSIndexPath(forRow: 2, inSection: 1)))
                            case .Failure:  fail("SectionDataFactoryType return error unexpectedly.")
                            }
                        })
                    })
                })
            })

            describe("hasRowData()", {
                context("with sectionDataList which have not empty rowDataList", {
                    it("will return true", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        expect(tableViewAndRelatedModules.dataSource.hasRowData()).to(beTrue())
                    })
                })
                context("with sectionDataList which have empty rowDataList", {
                    it("will return false", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.sectionDataFactory.rowDataCount = 0
                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ result in
                            expect(tableViewAndRelatedModules.dataSource.hasRowData()).to(beFalse())
                        })
                    })
                })
                context("with sectionDataList which is empty", {
                    it("will return false", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.sectionDataFactory.sectionCount = 0
                        tableViewAndRelatedModules.sectionDataFactory.rowDataCount = 0

                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ result in
                            expect(tableViewAndRelatedModules.dataSource.hasRowData()).to(beFalse())
                        })
                    })
                })
            })

            describe("sectionDataList", {
                it("will return sectionData array", closure: {
                    let tableViewAndRelatedModules      = self.generateTableViewAndRelatedModules()
                    let dataSource: TableViewDataSource = tableViewAndRelatedModules.dataSource

                    expect(dataSource.sectionDataList.count).to(equal(2))
                })
            })
        }
    }

    private func generateTableViewAndRelatedModules() -> (tableView: UITableView, dataSource: TableViewDataSource, sectionDataFactory: DummySectionDataFactory) {
        let cellClassResolver                           = TableViewSingleCellClassResolver<DummyTableViewCell>.self
        let sectionDataFactory: DummySectionDataFactory = DummySectionDataFactory()
        sectionDataFactory.sectionCount = 2
        sectionDataFactory.rowDataCount = 3
        let dataSource: TableViewDataSource = TableViewDataSource(sectionDataFactory: sectionDataFactory, cellClassResolver: cellClassResolver)
        let tableView: UITableView          = UITableView()
        tableView.dataSource = dataSource

        return (tableView: tableView, dataSource: dataSource, sectionDataFactory: sectionDataFactory)
    }
}

private class DummyRowData: RowData {
    var indexPath: NSIndexPath
    var title: String

    init(indexPath: NSIndexPath) {
        self.indexPath = indexPath
        self.title = "dummy title \(indexPath.section)\(indexPath.row)"
    }

    override func isEqual(object: AnyObject?) -> Bool {
        guard let object = object as? DummyRowData else {
            return false
        }

        return indexPath == object.indexPath
    }
}

private class DummyTableViewCell: UITableViewCell, RowDataAcceptableType {
    private(set) var rowData: DummyRowData?

    func update(rowData: RowData) {
        guard let rowData = rowData as? DummyRowData else {
            return
        }

        self.rowData = rowData
    }
}

private class DummySectionDataFactory: SectionDataFactoryType {
    var sectionCount: Int = 0
    var rowDataCount: Int = 0

    private func create(for section: Int, completion: ((sectionData: SectionData, error: NSError?) -> Void)) {
        let rowDataList: [DummyRowData] = [Int](0..<rowDataCount).map({
            DummyRowData.init(indexPath: NSIndexPath(forRow: $0, inSection: section))
        })

        completion(sectionData: SectionData(rowDataList: rowDataList), error: nil)
    }

    func numberOfSections() -> Int {
        return sectionCount
    }
}
