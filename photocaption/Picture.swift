//
//  Picture.swift
//  photocaption
//
//  Created by Kristoffer Eriksson on 2020-10-08.
//

import UIKit
//custom type to handle picture object / codable to save in userdefaults
class Picture: NSObject, Codable {
    
    var name: String
    var image: String
    var caption: String
    
    init(name: String, image: String, caption: String){
        self.name = name
        self.image = image
        self.caption = caption
    }
}
