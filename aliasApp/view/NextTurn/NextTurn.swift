//
//  NextTurn.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 17/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

class NextTurn: UIView {

    @IBOutlet weak var timLabel: UILabel!
    @IBOutlet weak var citaLabel: UILabel!
    @IBOutlet weak var pogadjaLabel: UILabel!
   
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func pokreniBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
}
