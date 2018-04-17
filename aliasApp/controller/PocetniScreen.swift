//
//  PocetniScreen.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

class PocetniScreen: UIViewController {
    
    @IBOutlet weak var TeamTableView: UITableView!

    var timovi = [Team]()
    var bojeTimova : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.magenta, UIColor.yellow]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTeamTable()
    
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
            if self.timovi.count == 5 {
                sender.isEnabled = false
                sender.setTitle("puno", for: .normal)
            }
            
            self.updateTeamTable()
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

  
    

    
}

extension PocetniScreen: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timovi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStack", for: indexPath) as! TeamStack
    
        cell.timLabel.text = "TIM \(indexPath.row+1)"
        cell.igrac1Label.text = timovi[indexPath.row].igrac1
        cell.igrac2Label.text = timovi[indexPath.row].igrac2
        cell.score.text = ""
        cell.pozadinaTima.backgroundColor = bojeTimova[indexPath.row]
    
        return cell
    }
    
    private func configureTeamTable () {
        TeamTableView.delegate = self
        TeamTableView.dataSource = self
        
        TeamTableView.register(UINib(nibName: "TeamStack", bundle: nil), forCellReuseIdentifier: "TeamStack")
        
        TeamTableView.rowHeight = 60
//        TeamTableView.isScrollEnabled = false
    }
    
    private func updateTeamTable () {
        
        TeamTableView.reloadData()
//        setTableHeight()

    }
    
    private func setTableHeight () {
        var theHeight : CGFloat = 0.0
        let kucica = self.TeamTableView.visibleCells
        
        for cell in kucica {
            theHeight += cell.frame.height
        }
        
        TeamTableView.frame = CGRect(x: TeamTableView.frame.origin.x, y: TeamTableView.frame.origin.y, width: TeamTableView.frame.width, height: CGFloat(theHeight))
        
    }
    
    
}
