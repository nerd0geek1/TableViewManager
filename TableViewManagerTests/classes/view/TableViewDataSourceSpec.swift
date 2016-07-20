//
//  TableViewDataSourceSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/04.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

class TableViewDataSourceSpec: QuickSpec {
    override func spec() {
        describe("TableViewDataSource") {
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

                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ (insertedIndexPaths, removedIndexPaths) in
                            expect(insertedIndexPaths.count).to(equal(3))
                            expect(removedIndexPaths.count).to(equal(0))

                            expect(insertedIndexPaths[0]).to(equal(NSIndexPath(forRow: 0, inSection: 2)))
                            expect(insertedIndexPaths[1]).to(equal(NSIndexPath(forRow: 1, inSection: 2)))
                            expect(insertedIndexPaths[2]).to(equal(NSIndexPath(forRow: 2, inSection: 2)))
                        })
                    })
                })
                context("when some UITableViewCells are removed", {
                    it("will return empty insertedIndexPaths, empty removedIndexPaths", closure: {
                        let tableViewAndRelatedModules = self.generateTableViewAndRelatedModules()

                        tableViewAndRelatedModules.sectionDataFactory.rowDataCount = 2
                        tableViewAndRelatedModules.dataSource.updateSectionDataList({ (insertedIndexPaths, removedIndexPaths) in
                            expect(insertedIndexPaths.count).to(equal(0))
                            expect(removedIndexPaths.count).to(equal(2))

                            expect(removedIndexPaths[0]).to(equal(NSIndexPath(forRow: 2, inSection: 0)))
                            expect(removedIndexPaths[1]).to(equal(NSIndexPath(forRow: 2, inSection: 1)))
                        })
                    })
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

    func create(for section: Int, completion: ((result: SectionData) -> Void)) {
        let rowDataList: [DummyRowData] = [Int](0..<rowDataCount).map({ DummyRowData.init(indexPath: NSIndexPath(forRow: $0, inSection: section)) })

        completion(result: SectionData(rowDataList: rowDataList))
    }

    func numberOfSections() -> Int {
        return sectionCount
    }
}
