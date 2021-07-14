//
//  Array+Only.swift
//  Memorize
//
//  Created by Андрей on 12.07.2021.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
