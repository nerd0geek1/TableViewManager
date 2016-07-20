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
    public var canEditRow: ((indexPath: NSIndexPath) -> Bool)?
    public var didEditRow: ((editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) -> Void)?

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

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let canEditRow = canEditRow {
            return canEditRow(indexPath: indexPath)
        }

        return false
    }

    public func tableView(tableView: UITableView,
                          commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                          forRowAtIndexPath indexPath: NSIndexPath) {
        didEditRow?(editingStyle: editingStyle, indexPath: indexPath)
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

        fetchNewSectionDataList {[weak self] newSectionDataList in
            if let unwrapped = self {
                let insertedIndexPaths: [NSIndexPath] = unwrapped.insertedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList)
                let removedIndexPaths: [NSIndexPath]  = unwrapped.removedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList)

                unwrapped.sectionDataList = newSectionDataList

                completion?(insertedIndexPaths: insertedIndexPaths, removedIndexPaths: removedIndexPaths)
            }
        }
    }

    //MARK: - private

    private func fetchNewSectionDataList(completion: ((newSectionDataList: [SectionData]) -> Void)) {
        fetchNewSectionDataList(currentIndex: 0,
                                endIndex: sectionDataFactory.numberOfSections() - 1,
                                fetchedSectionDataList: []) { result in
                                    completion(newSectionDataList: result)
        }
    }

    private func fetchNewSectionDataList(currentIndex currentIndex: Int,
                                                      endIndex: Int,
                                                      fetchedSectionDataList: [SectionData],
                                                      completion: ((result: [SectionData]) -> Void)) {
        sectionDataFactory.create(for: currentIndex) {[weak self] result in
            var fetchedSectionDataList: [SectionData] = fetchedSectionDataList
            fetchedSectionDataList.append(result)

            if currentIndex == endIndex {
                completion(result: fetchedSectionDataList)
            } else {
                self?.fetchNewSectionDataList(currentIndex: currentIndex + 1,
                                              endIndex: endIndex,
                                              fetchedSectionDataList: fetchedSectionDataList,
                                              completion: completion)
            }
        }
    }

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
