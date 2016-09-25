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
    public var didSelectRow: ((IndexPath) -> Void)?
    public var didDeselectRow: ((IndexPath) -> Void)?
    public weak var dataSource: TableViewDataSource?

    //MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow?(indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellClass: UITableViewCell.Type? = dataSource?.cellClassResolver.cellClass(for: indexPath)

        if let cellClass = cellClass, let customizedHeightCellClass = cellClass as? CustomizedCellHeightType.Type {
            return customizedHeightCellClass.customizedHeight
        }

        return 44
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionData(for: section)?.headerData?.headerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = self.sectionData(for: section) else {
            return nil
        }

        let sectionHeaderView = sectionData.headerView
        if let sectionHeaderView = sectionHeaderView as? SectionHeaderDataAcceptableType, let sectionHeaderData = sectionData.headerData {
            sectionHeaderView.update(sectionHeaderData)
        }

        return sectionHeaderView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionData(for: section)?.footerData?.footerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionData = self.sectionData(for: section) else {
            return nil
        }

        let sectionFooterView = sectionData.footerView

        if let sectionFooterView = sectionFooterView as? SectionFooterDataAcceptableType, let sectionFooterData = sectionData.footerData {
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
