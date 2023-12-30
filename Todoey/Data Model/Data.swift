//
//  Data.swift
//  Todoey
//
//  Created by Paul Hanson on 12/29/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    //'dynamic' is a declaration modifier, tells runtime to use dynamic dispatch, not static, it is monitored for changes while running
}
