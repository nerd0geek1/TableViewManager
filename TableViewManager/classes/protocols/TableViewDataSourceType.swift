//
//  TableViewDataSourceType.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit
import Result

public typealias SectionDataListUpdateResult = Result<(insertedIndexPaths: [IndexPath], removedIndexPaths: [IndexPath]), NSError>

public protocol TableViewDataSourceType: UITableViewDataSource {
    var setupCellConnection: ((_ indexPath: IndexPath, _ cell: UITableViewCell) -> Void)? { get set }
    var canEditRow: ((_ indexPath: IndexPath) -> Bool)? { get set }
    var didEditRow: ((_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void)? { get set }

    var sectionDataList: [SectionData] { get }

    func sectionCount() -> Int
    func allRowDataList() -> [RowData]
    func rowData(at indexPath: IndexPath) -> RowData?
    func hasRowData() -> Bool
    func updateSectionDataList(_ completion: ((_ result: SectionDataListUpdateResult) -> Void)?)
}
