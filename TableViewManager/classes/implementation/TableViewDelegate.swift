//
//  TableViewDelegate.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import UIKit

public class TableViewDelegate: NSObject, TableViewDelegateType {
    public var didSelectRow: (NSIndexPath -> Void)?
    public var didDeselectRow: (NSIndexPath -> Void)?
    public weak var dataSource: TableViewDataSource?

    //MARK: - UITableViewDelegate

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        didSelectRow?(indexPath)
    }

    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        didDeselectRow?(indexPath)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let cell = tableView.cellForRowAtIndexPath(indexPath), customizedHeightCell = cell as? CustomizedCellHeightType {
            return customizedHeightCell.dynamicType.customizedHeight
        }

        return 44
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionData(for: section)?.headerData?.headerHeight ?? 0
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = self.sectionData(for: section) else {
            return nil
        }

        let sectionHeaderView = sectionData.headerView
        if let sectionHeaderView = sectionHeaderView as? SectionHeaderDataAcceptableType, sectionHeaderData = sectionData.headerData {
            sectionHeaderView.update(sectionHeaderData)
        }

        return sectionHeaderView
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionData(for: section)?.footerData?.footerHeight ?? 0
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionData = self.sectionData(for: section) else {
            return nil
        }

        let sectionFooterView = sectionData.footerView

        if let sectionFooterView = sectionFooterView as? SectionFooterDataAcceptableType, sectionFooterData = sectionData.footerData {
            sectionFooterView.update(sectionFooterData)
        }

        return sectionFooterView
    }

    //MARK: - private

    private func sectionData(for section: Int) -> SectionData? {
        guard let dataSource = dataSource else {
            return nil
        }

        if section > dataSource.sectionDataList.count - 1 {
            return nil
        }

        return dataSource.sectionDataList[section]
    }
}
