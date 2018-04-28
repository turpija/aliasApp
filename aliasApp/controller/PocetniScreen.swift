//
//  PocetniScreen.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import RealmSwift

class PocetniScreen: UIViewController {
    
    @IBOutlet weak var TeamTableView: UITableView!

//    var timovi = [Team]()
    var bojeTimova : [UIColor] = [UIColor.orange, UIColor.blue, UIColor.green, UIColor.magenta, UIColor.purple]
  
    var timovi: Results<Team>?
    
    let realm = try! Realm()
    
    
////////////////////// REALM SNIMANJE POJMOVA U BAZU
    
    var pojmovi1: Array = ["napušten","zbuniti","neprilika","poništiti","smanjiti","utišati","klaonica","trag","samostan","abeceda","trbuh","milijon","malo","noćenje","prije podne"]
    var pojmovi2: Array = ["očaj","gležanj","abortus","talent","moć","opak","okolo","blizu","boravak"]
    let pojmovi3: Array = ["osramotiti","prodaja","pustiti","trenje","mravojed","gore","nemar"]
    
    
    private func popuniRealmBazu(pojmovi: Array<String>, lvl: Int) {
   
        pojmovi.forEach {
            print($0)
        
            let item = Pojmovi()
            item.pojam = $0
            item.seen = 0
            item.lvl = lvl
            
            print(item, item.pojam, item.seen, item.lvl)
            
            do {
                try realm.write {
                    realm.add(item)
                }
            } catch {
                print ("error saving realm \(error)")
            }
        }
        

    }

    private func realmQuerry () {
        let levelPrvi = realm.objects(Pojmovi.self).filter("lvl = 1 AND seen = 0")
        
        let sortiranoPoLevelima = realm.objects(Pojmovi.self).sorted(byKeyPath: "lvl")
        
        let seenDva = realm.objects(Pojmovi.self).filter("seen = 2")
        print("/////////////////")
        
        let rand = Int(arc4random_uniform(UInt32(levelPrvi.count)))
        
        seenPojam(pojam: levelPrvi[rand])
    }
    
    private func seenPojam(pojam: Pojmovi) {
        do {
            try realm.write {
                pojam.seen = 1
            }
        } catch {
            print ("error seen=1, \(error)")
        }
        
    }
    
    
///////////////////////////////////
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRealm()
        configureTeamTable()
//        popuniRealmBazu(pojmovi: pojmovi3, lvl: 3)
//        realmQuerry()
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
            } else { noviTim.naziv = "tim" }
            
            if igrac1.text != "" {
                noviTim.igrac1 = igrac1.text!
            } else { noviTim.igrac1 = "igrač 1" }
            
            if igrac2.text != "" {
                noviTim.igrac2 = igrac2.text!
            } else { noviTim.igrac2 = "igrač 2" }
                        
//            self.timovi.append(noviTim)
            self.saveRealm(tim: noviTim)
            
            if self.timovi?.count == 5 {
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
        performSegue(withIdentifier: "gameSeque", sender: self)
 //       self.present(GameScreen(),animated: true, completion: nil)
        
    }
    

    
}

//MARK: - TABLE EXTENSION

extension PocetniScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timovi?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStack", for: indexPath) as! TeamStack

        if timovi != nil {
            cell.timLabel.text = "TIM \(indexPath.row+1)"
        } else {
            cell.timLabel.text = "nema timova"
        }

        cell.igrac1Label.text = timovi?[indexPath.row].igrac1 ?? ""
        cell.igrac2Label.text = timovi?[indexPath.row].igrac2 ?? ""
        cell.score.text = "bodovi 0"
//        cell.pozadinaTima.backgroundColor = UIColor.yellow
        cell.contentView.isUserInteractionEnabled = false
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("buton \(indexPath.row)")
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            print("Deleted\(indexPath)")
//            self.timovi.remove(at: indexPath.row)
//            self.TeamTableView.deleteRows(at: [indexPath], with: .automatic)
/*            do {
                try realm.write {
                    self.realm.delete(self.timovi![indexPath.row])
                }
            } catch {
                print("error deleting team \(error)")
            }
        
*/
            deleteTeam(at: indexPath)

        }
    }
 
    
    private func configureTeamTable () {
        TeamTableView.delegate = self
        TeamTableView.dataSource = self
        
        TeamTableView.register(UINib(nibName: "TeamStack", bundle: nil), forCellReuseIdentifier: "TeamStack")
        
        TeamTableView.rowHeight = 60
        TeamTableView.allowsSelection = false
        TeamTableView.isScrollEnabled = false
    }
    
    private func updateTeamTable () {
        TeamTableView.reloadData()
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

//MARK: - REALM, load & save

extension PocetniScreen {
    
    func saveRealm (tim: Team) {
        do {
            try realm.write {
                realm.add(tim)
            }
        } catch {
            print ("error saving realm \(error)")
        }
    }
    
    func loadRealm() {
        timovi = realm.objects(Team.self)
    }
    
    func deleteTeam(at indeksPath: IndexPath) {
       
        print ("delete team at: \(indeksPath)")
        
        if let timDelete = self.timovi?[indeksPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(timDelete)
                    updateTeamTable()
                }
            } catch {
                print("error deleting team \(error)")
            }
        } else {
            print ("nema timova -> no deletion")
        }
    }
    
}



    

 
