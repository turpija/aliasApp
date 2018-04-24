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
    
    
    
    let vrijemeIgre = 9
    var vrijemeTimera: Int = 0
    
    var timer = Timer()
    var timovi: Results<Team>?
    var currentTeamPlay: Int = 0
    
    var currentPojam: Int = 0
    var currentTeamBodovi:Int = 0
    
    var nextTurnProzor = NextTurn()
    let realm = try! Realm()
    
     let pojmovi:Array = ["auto","kuća","laptop","marljiv","tupav"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadRealm()
        nextTurnScreen()
        
    }
    
    func loadRealm() {
        print("učitaj timovi iz realma")
        timovi = realm.objects(Team.self)
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
        
        pojam.text = pojmovi[currentPojam]
        bodovi.text = "bodovi: \(currentTeamBodovi)"
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
    
    //timer
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
    
    private func updateView() {
        vrijeme.text = "start"
        bodovi.text = "bodovi: \(currentTeamBodovi)"
        pojam.text = pojmovi[0]
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
    
    
}

//MARK: - NextTurnDelegate

extension GameScreen: NextTurnDelegate {

    func startGame(string: String) {
        print("pokreni igru")
        pokreniIgru()
    }

}

