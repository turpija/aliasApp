//
//  Data.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 17/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var pojam: String = ""
    @objc dynamic var seen: Int = 0
    
    
    
}
