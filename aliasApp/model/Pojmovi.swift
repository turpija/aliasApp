//
//  Data.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 17/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import Foundation
import RealmSwift

class Pojmovi: Object {
    
    @objc dynamic var pojam: String = ""
    @objc dynamic var lvl: Int = 0
    @objc dynamic var seen: Int = 0

}
