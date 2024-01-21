//
//  PageModel.swift
//  Gesture
//
//  Created by Sravanthi Chinthireddy on 21/01/24.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailImageName: String {
        return "thumb-" + imageName
    }
}
