//
//  Win.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 30/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

protocol WinDelegate {
    func naPocetak()
}

class Win: UIView {

    @IBOutlet weak var pobjedioJeLabel: UILabel!
    @IBOutlet weak var igrac1Label: UILabel!
    @IBOutlet weak var igrac2Label: UILabel!
    
    var delegate: WinDelegate?

    
    @IBAction func josJednuBtn(_ sender: Any) {
        delegate?.naPocetak()
        self.removeFromSuperview()        

    }
    
    
    
    

}
