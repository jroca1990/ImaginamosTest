//
//  extensions.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
