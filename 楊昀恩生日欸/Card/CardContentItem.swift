//
//  CardContentItem.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import Foundation
import SwiftUI

struct CardContentItem: Identifiable {
    let id = UUID()
    var text: String
    var image: Image?
    let isShowButton: Bool?
    
    init(text: String, image: Image? = nil, isShowButton: Bool? = nil) {
        self.text = text
        self.image = image
        self.isShowButton = isShowButton
    }
}
