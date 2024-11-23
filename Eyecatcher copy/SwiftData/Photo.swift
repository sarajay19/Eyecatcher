//
//  Photo.swift
//  Eyecatcher
//
//  Created by Khozama on 19/05/2024.
//

import SwiftData
import Foundation


@Model
class Photo {
    @Attribute(.externalStorage) var imageData:Data
    var category : Category?
    
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}

