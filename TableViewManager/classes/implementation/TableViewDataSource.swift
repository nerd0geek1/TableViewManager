//
//  TableViewDataSource.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public class TableViewDataSource: NSObject, TableViewDataSourceType {

    public var setupCellConnection: ((_ indexPath: IndexPath, _ cell: UITableViewCell) -> Void)?
    public var canEditRow: ((_ indexPath: IndexPath) -> Bool)?
    public var didEditRow: ((_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void)?

    private let sectionDataFactory: SectionDataFactoryType
    let cellClassResolver: TableViewCellClassResolverType.Type

    public var sectionDataList: [SectionData] {
        return internalSectionDataList
    }

    private var internalSectionDataList: [SectionData] = [] {
        didSet {
            didUpdateSectionDataList()
        }
    }

    public init(sectionDataFactory: SectionDataFactoryType, cellClassResolver: TableViewCellClassResolverType.Type) {
        self.sectionDataFactory = sectionDataFactory
        self.cellClassResolver  = cellClassResolver

        super.init()

        updateSectionDataList(nil)
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= sectionDataList.count {
            return 0
        }

        return sectionDataList[section].numberOfRows()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellClass: UITableViewCell.Type = cellClassResolver.cellClass(for: indexPath)

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.identifier) {
            if let cell = cell as? RowDataAcceptableType, let rowData = self.rowData(at: indexPath) {
                cell.update(rowData)
            }
            setupCellConnection?(indexPath, cell)

            return cell
        }

        return UITableViewCell()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDataList.count
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let canEditRow = canEditRow {
            return canEditRow(indexPath)
        }

        return false
    }

    public func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
        didEditRow?(editingStyle, indexPath)
    }

    // MARK: - TableViewDataSourceType

    public func sectionCount() -> Int {
        return sectionDataList.count
    }

    public func allRowDataList() -> [RowData] {
        var allRowDataList: [RowData] = []

        for sectionData in sectionDataList {
            allRowDataList.append(contentsOf: sectionData.rowDataList)
        }

        return allRowDataList
    }

    public func rowData(at indexPath: IndexPath) -> RowData? {
        if indexPath.section >= sectionDataList.count {
            return nil
        }

        return sectionDataList[indexPath.section].rowData(at: indexPath.row)
    }

    public func hasRowData() -> Bool {
        return !allRowDataList().isEmpty
    }

    public func updateSectionDataList(_ completion: (((inserted: [IndexPath], removed: [IndexPath]), Error?) -> Void)?) {
        let currentSectionDataList: [SectionData] = self.sectionDataList

        fetchNewSectionDataList {[weak self] (newSectionDataList, error) in
            if let error = error {
                completion?(([], []), error)
                return
            }

            let insertedIndexPaths: [IndexPath] = self?.insertedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList) ?? []
            let removedIndexPaths: [IndexPath]  = self?.removedIndexPaths(currentSectionDataList, newSectionDataList: newSectionDataList) ?? []

            self?.internalSectionDataList = newSectionDataList

            completion?((insertedIndexPaths, removedIndexPaths), nil)
        }
    }

    // MARK: - internal

    func didUpdateSectionDataList() {}

    // MARK: - private

    private func fetchNewSectionDataList(_ completion: @escaping ((_ newSectionDataList: [SectionData], _ error: Error?) -> Void)) {
        let endIndex: Int = sectionDataFactory.numberOfSections() == 0 ? 0 : sectionDataFactory.numberOfSections() - 1

        fetchNewSectionDataList(from: 0,
                                to: endIndex,
                                fetchedSectionDataList: [],
                                completion: completion)
    }

    private func fetchNewSectionDataList(from startIndex: Int,
                                         to endIndex: Int,
                                         fetchedSectionDataList: [SectionData],
                                         completion: @escaping ((_ newSectionDataList: [SectionData], _ error: Error?) -> Void)) {

        sectionDataFactory.create(for: startIndex) {[weak self] (sectionData, error) in
            if let error = error {
                completion([], error)
                return
            }

            var fetchedSectionDataList: [SectionData] = fetchedSectionDataList
            fetchedSectionDataList.append(sectionData)

            if startIndex == endIndex {
                completion(fetchedSectionDataList, nil)
            } else {
                self?.fetchNewSectionDataList(from: startIndex + 1,
                                              to: endIndex,
                                              fetchedSectionDataList: fetchedSectionDataList,
                                              completion: completion)
            }
        }
    }

    private func insertedIndexPaths(_ currentSectionDataList: [SectionData], newSectionDataList: [SectionData]) -> [IndexPath] {
        var insertedIndexPaths: [IndexPath] = []
        for i in 0..<newSectionDataList.count {
            let isExistingSection: Bool          = i <= currentSectionDataList.count - 1
            let newSectionData: SectionData      = newSectionDataList[i]
            let currentSectionData: SectionData? = isExistingSection ? currentSectionDataList[i] : nil

            for j in 0..<newSectionData.numberOfRows() {
                var didInsert: Bool = false
                if let currentSectionData = currentSectionData, let currentRowData = currentSectionData.rowData(at: j) {
                    if newSectionData.rowData(at: j) != currentRowData {
                        didInsert = true
                    }
                } else {
                    didInsert = true
                }

                if didInsert {
                    insertedIndexPaths.append(IndexPath(row: j, section: i))
                }
            }
        }
        return insertedIndexPaths
    }

    private func removedIndexPaths(_ currentSectionDataList: [SectionData], newSectionDataList: [SectionData]) -> [IndexPath] {
        var removedIndexPaths: [IndexPath] = []
        for i in 0..<currentSectionDataList.count {
            let isRemainingSection: Bool        = i <= newSectionDataList.count - 1
            let currentSectionData: SectionData = currentSectionDataList[i]
            let newSectionData: SectionData?    = isRemainingSection ? newSectionDataList[i] : nil

            for j in 0..<currentSectionData.numberOfRows() {
                var didRemoved: Bool = false
                if let newSectionData = newSectionData, let newRowData = newSectionData.rowData(at: j) {
                    if currentSectionData.rowData(at: j) != newRowData {
                        didRemoved = true
                    }
                } else {
                    didRemoved = true
                }

                if didRemoved {
                    removedIndexPaths.append(IndexPath(row: j, section: i))
                }
            }
        }

        return removedIndexPaths
    }
}
