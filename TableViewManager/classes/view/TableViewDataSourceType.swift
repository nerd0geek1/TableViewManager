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

    func rowData(at indexPath: NSIndexPath) -> RowData?
    func updateSectionDataList(completion: ((insertedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath]) -> Void)?)
}
