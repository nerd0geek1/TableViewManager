//
//  SectionDataFactoryType.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 6/23/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public protocol SectionDataFactoryType {
    func numberOfSections() -> Int
    func create(for section: Int, completion: @escaping ((_ sectionData: SectionData, _ error: Error?) -> Void))
}
