//
//  PocetniScreen.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

class PocetniScreen: UIViewController {
    
    var timovi = [Team]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dodajTim(_ sender: UIButton) {
        var naziv = UITextField()
        var igrac1 = UITextField()
        var igrac2 = UITextField()
        let alert = UIAlertController(title: "upiši ime tima i igrače", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "dodaj", style: .default) { (action) in

            let noviTim = Team()
            
            if naziv.text != "" {
                noviTim.naziv = naziv.text!
            } else {
                noviTim.naziv = "tim"
            }
            
            if igrac1.text != "" {
                noviTim.igrac1 = igrac1.text!
            } else {
                noviTim.igrac1 = "igrač 1"
                
            }
            
            if igrac2.text != "" {
                noviTim.igrac2 = igrac2.text!
            } else {
                noviTim.igrac2 = "igrač 2"
            }
            
            self.timovi.append(noviTim)
            self.iscrtajNoviTim(tim: noviTim)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "naziv tima"
            naziv = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "ime igrača 1"
            igrac1 = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "ime igrača 2"
            igrac2 = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        

    }

    
    
    @IBAction func start(_ sender: UIButton) {
    }

    
    func iscrtajNoviTim (tim: Team) {
        print(timovi[0])
        
        let naziv = UILabel()
        naziv.frame = CGRect(x: 0, y: 20, width: 200, height: 20)
        naziv.text = tim.naziv
        self.view.addSubview(naziv)
        
        let igrac1 = UILabel()
        igrac1.frame = CGRect(x: 100, y: 0, width: 200, height: 20)
        igrac1.text = tim.igrac1
        self.view.addSubview(igrac1)
        
        let igrac2 = UILabel()
        igrac2.frame = CGRect(x: 100, y: 40, width: 200, height: 20)
        igrac2.text = tim.igrac2
        self.view.addSubview(igrac2)
    }

    
    
}
