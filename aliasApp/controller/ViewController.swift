//
//  ViewController.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vrijeme: UILabel! // za prikaz timera odbrojavanja
    @IBOutlet weak var pojam: UILabel!  // za prikaz pojma koji se pogađa
    @IBOutlet weak var bodovi: UILabel!  // za prikaz bodova
    
    var vrijemeIgre = 20
    var timer = Timer()

    
    let pojmovi:Array = ["auto","kuća","laptop","marljiv","tupav"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startTimer()
        vrijeme.text = "start"
        bodovi.text = "bodovi: 0"
    }
    
    
    

    //MARK: - Buttoni
    
    //btn dalje - preskoči trenutni pojam, minus bod
    @IBAction func daljeBtn(_ sender: UIButton) {
        print("dalje")
    }
    //btn točno - dodaj bod, sljedeći pojam
    @IBAction func tocnoBtn(_ sender: UIButton) {
        print("točno")
        
    }
    
    //timer
    func startTimer () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        }
    
    @objc func updateTimer () {
        
        vrijeme.text = "vrijeme: \(vrijemeIgre) sec"
        
        if vrijemeIgre == 0 {
            timer.invalidate()
            vrijeme.text = "vrijeme je isteklo"
            zavrsiKrug()
        } else {
            vrijemeIgre -= 1
        }
    
    }
    
    func zavrsiKrug () {
        print("sljedeći")
    }
    
    
}

