//
//  NextTurn.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 17/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit


protocol NextTurnDelegate {
    func startGame(string: String)
}


class NextTurn: UIView {

    @IBOutlet weak var timLabel: UILabel!
    @IBOutlet weak var citaLabel: UILabel!
    @IBOutlet weak var pogadjaLabel: UILabel!
    @IBOutlet weak var bodoviLabel: UILabel!
    
    var delegate: NextTurnDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
    
    @IBAction func pokreniBtn(_ sender: UIButton) {
        delegate?.startGame(string: "sent from NextTurn")
        self.removeFromSuperview()

    }
    
    
}
