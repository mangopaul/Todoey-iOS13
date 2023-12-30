//
//  Category.swift
//  Todoey
//
//  Created by Paul Hanson on 12/29/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>() //initialized as empty list, this defines the forward relationship
}
