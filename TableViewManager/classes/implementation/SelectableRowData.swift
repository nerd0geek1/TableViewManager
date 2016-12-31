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

    // MARK: - public

    public func isSelected() -> Bool {
        return selected
    }

    public func setSelectedState(_ isSelected: Bool) {
        self.selected = isSelected
    }

    public func toggleSelectedState() {
        setSelectedState(!selected)
    }
}
