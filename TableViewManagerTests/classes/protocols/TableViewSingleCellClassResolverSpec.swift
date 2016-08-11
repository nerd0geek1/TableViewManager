//
//  TableViewSingleCellClassResolverSpec.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/04.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

class TableViewSingleCellClassResolverSpec: QuickSpec {
    override func spec() {
        describe("TableViewSingleCellClassResolver") {
            describe("registeredCellClasses()", {
                it("will return array which only includes Generic Class", closure: {
                    let cellClassResolver: TableViewSingleCellClassResolver<SampleTableViewCell>.Type = TableViewSingleCellClassResolver<SampleTableViewCell>.self
                    let registeredCellClasses: [UITableViewCell.Type]                                 = cellClassResolver.registeredCellClasses()

                    expect(registeredCellClasses.count).to(equal(1))
                    expect(registeredCellClasses[0] is SampleTableViewCell.Type).to(beTrue())
                })
            })
            describe("cellClass(for indexPath: NSIndexPath)", {
                it("will return Generic Class", closure: {
                    let cellClassResolver: TableViewSingleCellClassResolver<SampleTableViewCell>.Type = TableViewSingleCellClassResolver<SampleTableViewCell>.self
                    let cellClass: UITableViewCell.Type                                               = cellClassResolver.cellClass(for: NSIndexPath(forRow: 0, inSection: 0))

                    expect(cellClass is SampleTableViewCell.Type).to(beTrue())
                })
            })
        }
    }
}

class SampleTableViewCell: UITableViewCell {}
