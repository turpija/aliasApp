//
//  ViewController.swift
//  aliasApp
//
//  Created by Ivan Kočiš on 15/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import RealmSwift

class GameScreen: UIViewController {

    @IBOutlet weak var vrijeme: UILabel! // za prikaz timera odbrojavanja
    @IBOutlet weak var pojam: UILabel!  // za prikaz pojma koji se pogađa
    @IBOutlet weak var bodovi: UILabel!  // za prikaz bodova
    
    
    
    var vrijemeIgre: Int = 9  // napraviti user input trajanja runde
    var vrijemeTimera: Int = 0
    var brojBodovaZaPobjedu: Int = 30  // napraviti user input max broj bodova za pobjedu
    
    var timer = Timer()
    var timovi: Results<Team>?
    var currentTeamPlay: Int = 0
    
    var currentPojam: Int = 0
    var currentTeamBodovi:Int = 0
    var level2Bodovi: Int = 10   // napraviti funkciju da automatski određuje level 2 u odnosu na max broj bodova
    
    var nextTurnProzor = NextTurn()
    let realm = try! Realm()
    
    let pojmovi:Array = ["0auto","1kuća","2laptop","3marljiv","4tupav"]
    var pojmovi1: Results<Pojmovi>?
    var pojmovi2: Results<Pojmovi>?
    var pojmovi3: Results<Pojmovi>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadRealm()
        resetirajBodoveTimovima()
        nextTurnScreen()
        
    }
    
    func loadRealm() {
//        print("učitaj timovi iz realma")
        timovi = realm.objects(Team.self)
  
        pojmovi1 = realm.objects(Pojmovi.self).filter("lvl = 1 AND seen = 0")
        pojmovi2 = realm.objects(Pojmovi.self).filter("lvl = 2 AND seen = 0")
        pojmovi3 = realm.objects(Pojmovi.self).filter("lvl = 3 AND seen = 0")
        
    }
    
    private func nextTurnScreen() {
        nextTurnProzor = UINib(nibName: "NextTurn", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! NextTurn
        
        sljedeciTeamIgra()
        
        nextTurnProzor.delegate = self
    }
    
    
    private func pokreniIgru () {
        startTimer()
        updateView()
    }
    
    private func drugiPojam (dodajBodove: Int) {
        currentPojam += 1
        currentTeamBodovi += dodajBodove
        
        pojam.text = ucitajPojam()
        bodovi.text = "bodovi: \(currentTeamBodovi)"
        
        //zapiši seen = 1 u realm
    }
    
    private func ucitajPojam () -> String {           // level 1 -> učitaj random pojam1
        if currentTeamBodovi < level2Bodovi {
            
            if pojmovi1?.count == 0 {
                print("pojmovi1.count = 0 ...")
                
                let pojmoviZaReset = realm.objects(Pojmovi.self).filter("lvl = 1")
                resetSeen(pojmovi: pojmoviZaReset)
            }
 
//            print("broj pojmova u arrayu \(pojmovi1!.count)")
            let randIndeks = randomIndex(zaArray: pojmovi1!)
            let tekst = "1.\(pojmovi1![randIndeks].pojam)"
            seenPojam(pojam: pojmovi1![randIndeks])
            return tekst

        } else {
            
            if pojmovi2?.count == 0 {
                print("pojmovi2.count = 0 ...")
                
                let pojmoviZaReset = realm.objects(Pojmovi.self).filter("lvl = 2")
                resetSeen(pojmovi: pojmoviZaReset)
            }
            
            let randIndeks = randomIndex(zaArray: pojmovi2!)
            let tekst = "2.\(pojmovi2![randIndeks].pojam)"
            seenPojam(pojam: pojmovi2![randIndeks])
            return tekst

        }

        
        // level 2 -> učitaj random pojam2
        // level 2, netočno 4x -> učitaj random pojam1
        // 4x točno -> učitaj random pojam3, bonus
        
        return "blank"
    }
    
    private func randomIndex (zaArray: Results<Pojmovi>) -> Int {
        return Int(arc4random_uniform(UInt32(zaArray.count)))
    }
    
// reset seen na 0
    private func resetSeen(pojmovi: Results<Pojmovi>) {
        
        pojmovi.forEach {
            
            let item = $0
            
            do {
                try realm.write {
                    item.seen = 0
                }
            } catch {
                print ("error saving realm \(error)")
            }
        }
    }
    
// viđeno na 1
    private func seenPojam(pojam: Pojmovi) {
        print ("zapiši viđeno")
        do {
            try realm.write {
                pojam.seen = 1
            }
        } catch {
            print ("error seen=1, \(error)")
        }
        
    }
    
    
    

//MARK: - Buttoni
    
    //btn dalje - preskoči trenutni pojam, minus bod
    @IBAction func daljeBtn(_ sender: UIButton) {
        print("dalje")
        drugiPojam(dodajBodove: -1)
    }
    //btn točno - dodaj bod, sljedeći pojam
    @IBAction func tocnoBtn(_ sender: UIButton) {
        print("točno")
        drugiPojam(dodajBodove: 1)
    }
    
// TIMER
    func startTimer () {
        vrijemeTimera = vrijemeIgre
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameScreen.updateTimer)), userInfo: nil, repeats: true)
        }
    
    @objc func updateTimer () {
        
        vrijeme.text = "vrijeme: \(vrijemeTimera) sec"
        
        if vrijemeTimera == 0 {
            timer.invalidate()
            zavrsiKrug()
            vrijemeTimera = vrijemeIgre
        } else {
            vrijemeTimera -= 1
        }
    }
    
// SUČELJE
    
    private func updateView() {
        vrijeme.text = "start"
        bodovi.text = "bodovi: \(currentTeamBodovi)"
        pojam.text = ucitajPojam()
    }
    
    func zavrsiKrug () {
        vrijeme.text = "vrijeme je isteklo"
        
        do {
            try realm.write {
                timovi![currentTeamPlay].bodovi = currentTeamBodovi
                print("snimljeni trenutni bodovi za tim \(currentTeamBodovi)")
            }
        } catch {
            print ("error saving realm \(error)")
        }
        
        if currentTeamPlay == (timovi?.count)! - 1 {
            currentTeamPlay = 0
        } else {
            currentTeamPlay += 1
        }
        print("trenutni timplay \(currentTeamPlay)")
        
        sljedeciTeamIgra()
        print("sljedeći")
    }
    
    private func sljedeciTeamIgra() {
        
        nextTurnProzor.citaLabel.text = timovi![currentTeamPlay].igrac1
        nextTurnProzor.pogadjaLabel.text = timovi![currentTeamPlay].igrac2
        nextTurnProzor.timLabel.text = timovi![currentTeamPlay].naziv
        nextTurnProzor.bodoviLabel.text = String(timovi![currentTeamPlay].bodovi)
        
        currentTeamBodovi = timovi![currentTeamPlay].bodovi
        
        view.addSubview(nextTurnProzor)
        updateView()
    }

// resetiraj bodove svakog tima na 0
    private func resetirajBodoveTimovima () {
        if timovi != nil {
            do {
                try realm.write {
                    timovi!.forEach({ (tim) in
                        tim.bodovi = 0
                    })
                }
            } catch {
                print("error brisanje bodova, realm \(error)")
            }
        } else {
            print ("nema timova za resetirati bodove")
        }
    }
    
    
}

//MARK: - NextTurnDelegate

extension GameScreen: NextTurnDelegate {

    func startGame(string: String) {
        print("pokreni igru")
        pokreniIgru()
    }

}

