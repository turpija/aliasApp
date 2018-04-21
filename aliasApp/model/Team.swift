//
//  Team.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import RealmSwift

class Team: Object {

    @objc dynamic var naziv: String = ""
    @objc dynamic var igrac1: String = ""
    @objc dynamic var igrac2: String = ""
    @objc dynamic var bodovi: Int = 0
//    var boja: UIColor = UIColor()
}
