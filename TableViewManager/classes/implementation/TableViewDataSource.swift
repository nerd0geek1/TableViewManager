//
//  TableViewDataSource.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit
import SwiftExtensions

public class TableViewDataSource: NSObject, TableViewDataSourceType {

    public var setupCellConnection: ((indexPath: NSIndexPath, cell: UITableViewCell) -> Void)?

    private let sectionDataFactory: SectionDataFactoryType
    let cellClassResolver: TableViewCellClassResolverType.Type

    private(set) var sectionDataList: [SectionData] = []

    public init(sectionDataFactory: SectionDataFactoryType, cellClassResolver: TableViewCellClassResolverType.Type) {
        self.sectionDataFactory = sectionDataFactory
        self.cellClassResolver  = cellClassResolver

        super.init()

        updateSectionDataList(nil)
    }

    //MARK: - UITableViewDataSource

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= sectionDataList.count {
            return 0
        }

        return sectionDataList[section].numberOfRows()
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellClass: UITableViewCell.Type = cellClassResolver.cellClass(for: indexPath)

        if let cell = tableView.dequeueReusableCellWithIdentifier(cellClass.cellIdentifier) {
            if let cell = cell as? RowDataAcceptableType, rowData = self.rowData(at: indexPath) {
                cell.update(rowData)
            }
            setupCellConnection?(indexPath: indexPath, cell: cell)

            return cell
        }

        return UITableViewCell()
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionDataList.count
    }

    //MARK: - TableViewDataSourceType

    public func rowData(at indexPath: NSIndexPath) -> RowData? {
        if indexPath.section >= sectionDataList.count {
            return nil
        }

        return sectionDataList[indexPath.section].rowData(at: indexPath.row)
    }

    public func updateSectionDataList(completion: ((insertedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath]) -> Void)?) {
        let currentSectionDataList: [SectionData] = self.sectionDataList
        let newSectionDataList: [SectionData] = [Int](0..<sectionDataFactory.numberOfSections()).map({ self.sectionDataFactory.create(for: $0) })

        let insertedIndexPaths: [NSIndexPath] = self.insertedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList)
        let removedIndexPaths: [NSIndexPath]  = self.removedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList)

        self.sectionDataList = newSectionDataList

        completion?(insertedIndexPaths: insertedIndexPaths, removedIndexPaths: removedIndexPaths)
    }

    //MARK: - private

    private func insertedIndexPaths(currentSectionDataList: [SectionData], newSectionDataList: [SectionData]) -> [NSIndexPath] {
        var insertedIndexPaths: [NSIndexPath] = []
        for i in 0..<newSectionDataList.count {
            let isExistingSection: Bool          = i <= currentSectionDataList.count - 1
            let newSectionData: SectionData      = newSectionDataList[i]
            let currentSectionData: SectionData? = isExistingSection ? currentSectionDataList[i] : nil

            for j in 0..<newSectionData.numberOfRows() {
                var didInsert: Bool = false
                if let currentSectionData = currentSectionData, currentRowData = currentSectionData.rowData(at: j) {
                    if newSectionData.rowData(at: j) != currentRowData {
                        didInsert = true
                    }
                } else {
                    didInsert = true
                }

                if didInsert {
                    insertedIndexPaths.append(NSIndexPath(forRow: j, inSection: i))
                }
            }
        }
        return insertedIndexPaths
    }

    private func removedIndexPaths(currentSectionDataList: [SectionData], newSectionDataList: [SectionData]) -> [NSIndexPath] {
        var removedIndexPaths: [NSIndexPath] = []
        for i in 0..<currentSectionDataList.count {
            let isRemainingSection: Bool        = i <= newSectionDataList.count - 1
            let currentSectionData: SectionData = currentSectionDataList[i]
            let newSectionData: SectionData?    = isRemainingSection ? newSectionDataList[i] : nil

            for j in 0..<currentSectionData.numberOfRows() {
                var didRemoved: Bool = false
                if let newSectionData = newSectionData, newRowData = newSectionData.rowData(at: j) {
                    if currentSectionData.rowData(at: j) != newRowData {
                        didRemoved = true
                    }
                } else {
                    didRemoved = true
                }

                if didRemoved {
                    removedIndexPaths.append(NSIndexPath(forRow: j, inSection: i))
                }
            }
        }

        return removedIndexPaths
    }
}
