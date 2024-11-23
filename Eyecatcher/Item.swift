//
//  Item.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
