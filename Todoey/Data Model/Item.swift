//
//  Item.swift
//  Todoey
//
//  Created by Paul Hanson on 12/29/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCateogry = LinkingObjects(fromType: Category.self, property: "items") //defines the reverse relationship
}
