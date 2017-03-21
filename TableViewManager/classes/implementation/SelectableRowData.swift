//
//  SelectableRowData.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 2016/07/19.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

open class SelectableRowData: RowData {
    public var didUpdateSelectedState: (() -> Void)?

    private var selected: Bool = false {
        didSet {
            didUpdateSelectedState?()
        }
    }

    // MARK: - open

    open func isSelected() -> Bool {
        return selected
    }

    open func setSelectedState(_ isSelected: Bool) {
        self.selected = isSelected
    }

    open func toggleSelectedState() {
        setSelectedState(!selected)
    }
}
