//
//  Category.swift
//  Eyecatcher
//
//  Created by Khozama on 19/05/2024.
//

import Foundation
import Foundation
import SwiftData

@Model
class Category {
    var name: String
    var icon: String
//    var icon : String
    @Relationship(deleteRule: .cascade) var images: [Photo] = []
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
//        self.icon = icon
    }
}
