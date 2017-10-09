//
//  String+Addition.swift
//  TableViewManager
//
//  Created by Kohei Tabata on 10/9/17.
//  Copyright © 2017 Kohei Tabata. All rights reserved.
//

import Foundation

extension String {
    static func className(of sourceClass: AnyClass) -> String {
        let targetAndClassName: String = String.init(describing: sourceClass)
        let separatedList: [String]    = targetAndClassName.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .components(separatedBy: " ")

        return separatedList[0]
    }
}
