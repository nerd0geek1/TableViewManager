//
//  TableViewDataSourceType.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDataSourceType: UITableViewDataSource {
    var setupCellConnection: ((indexPath: NSIndexPath, cell: UITableViewCell) -> Void)? { get set }
    var canEditRow: ((indexPath: NSIndexPath) -> Bool)? { get set }
    var didEditRow: ((editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) -> Void)? { get set }

    var sectionDataList: [SectionData] { get }

    func sectionCount() -> Int
    func allRowDataList() -> [RowData]
    func rowData(at indexPath: NSIndexPath) -> RowData?
    func hasRowData() -> Bool
    func updateSectionDataList(completion: ((insertedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath]) -> Void)?)
}
