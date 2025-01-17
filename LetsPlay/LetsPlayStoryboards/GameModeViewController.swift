//
//  GameModeViewController.swift
//  LetsPlayStoryboards
//
//  Created by Francesco Chiarello on 16/07/2019.
//  Copyright © 2019 Christian Marino. All rights reserved.
//

import UIKit
import WatchConnectivity
import AudioKit

class GameModeViewController: UIViewController, WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    
    
    let USER_DEFAULT_KEY_STRING = "chords_string"
    var userDefault = UserDefaults.standard

    // Labels shown in game mode, each label is associated with a button
    @IBOutlet weak var redButtonChord: UILabel!
    @IBOutlet weak var blueButtonChord: UILabel!
    @IBOutlet weak var greenButtonChord: UILabel!
    @IBOutlet weak var pinkButtonChord: UILabel!
    
//    Buttons
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var roseButton: UIButton!
    
/**********GUITAR-RELATED VARIABLES*****************/
    var guitar11: Guitar?
    var guitar21: Guitar?
    var guitar31: Guitar?
    var guitar41: Guitar?
    var guitar12: Guitar?
    var guitar22: Guitar?
    var guitar32: Guitar?
    var guitar42: Guitar?
    
    var flag1 = false
    var flag2 = false
    var flag3 = false
    var flag4 = false
    
    let itaEnMap = [
        "Do": "C",
        "Dom": "Cm",
        "Re": "D",
        "Rem": "Dm",
        "Mi": "E",
        "Mim": "Em",
        "Fa": "F",
        "Fam": "Fm",
        "Sol": "G",
        "Solm": "Gm",
        "La": "A",
        "Lam": "Am",
        "Si": "B",
        "Sim": "Bm",
    ]
    
    var toPlay: [String]!
    
/**************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Label rotation in game mode
        redButtonChord?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        blueButtonChord?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        greenButtonChord?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pinkButtonChord?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        if SessionManager.manager.isSessionSupported(){
            SessionManager.manager.setDelegate(self)
        }
        
        //        Construct appropriate namefiles for selected chords
        var selectedChords = Array<String>()
        if let testChords = userDefault.array(forKey: "chords_string"){
            selectedChords = testChords as! Array<String>
        }
        else {
            
            selectedChords = userDefault.string(forKey: "PreferredNotation") == "IT" ? ["Do","Do","Do","Do"] : ["A","A","A","A"];
        }
        toPlay = [String]()
        
        if userDefault.string(forKey: "PreferredNotation") == "IT"{
            toPlay.append(itaEnMap[selectedChords[0]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[1]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[2]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[3]]! + ".wav")
        }
        else{
            toPlay.append(selectedChords[0] + ".wav")
            toPlay.append(selectedChords[1] + ".wav")
            toPlay.append(selectedChords[2] + ".wav")
            toPlay.append(selectedChords[3] + ".wav")
        }
        
        //        Create guitars to play chords
//        Il numero zero è associato al rosso e così via
        do{
            guitar11 = try Guitar(file: toPlay[0])
            guitar21 = try Guitar(file: toPlay[1])
            guitar31 = try Guitar(file: toPlay[2])
            guitar41 = try Guitar(file: toPlay[3])
            guitar12 = try Guitar(file: toPlay[0])
            guitar22 = try Guitar(file: toPlay[1])
            guitar32 = try Guitar(file: toPlay[2])
            guitar42 = try Guitar(file: toPlay[3])
        }catch{
            print("Could not create guitar files")
        }
        
        //        create mixer, to allow repeated chords/multiple chords
        //        SE NON SUONA E' PERCHE' HO MESSO CHORDS QUI DENTRO E QUINDI SIGNIFICA CHE LA COSA VA GESTITA
        //        DIVERSAMENTE
        let mixer = AKMixer(guitar11?.chord, guitar21?.chord, guitar31?.chord, guitar41?.chord, guitar12?.chord, guitar22?.chord, guitar32?.chord, guitar42?.chord)
        AudioKit.output = mixer
        do{
            try AudioKit.start()
        }catch{
            print("Audiokit motor couldn't start!")
        }
        
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
        if SessionManager.manager.isSessionSupported(){
            SessionManager.manager.sendNoHandlers(["stop": 1])
        }
    }
    
//    WAS STATIC
    func play(){
        /*
//        Maps chords in italian notation to chords in english notation
        let itaEnMap = [
            "Do": "C",
            "Dom": "Cm",
            "Re": "D",
            "Rem": "Dm",
            "Mi": "E",
            "Mim": "Em",
            "Fa": "F",
            "Fam": "Fm",
            "Sol": "G",
            "Solm": "Gm",
            "La": "A",
            "Lam": "Am",
            "Si": "B",
            "Sim": "Bm",
        ]
        
        let userDefault = UserDefaults.standard
        var toPlay = [String]()
        var selectedChords = userDefault.array(forKey: "chords_string") as! Array<String>
        
//        Construct appropriate namefiles for selected chords
        if userDefault.string(forKey: "PreferredNotation") == "IT"{
            toPlay.append(itaEnMap[selectedChords[0]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[1]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[2]]! + ".wav")
            toPlay.append(itaEnMap[selectedChords[3]]! + ".wav")
        }
        else{
            toPlay.append(selectedChords[0] + ".wav")
            toPlay.append(selectedChords[1] + ".wav")
            toPlay.append(selectedChords[2] + ".wav")
            toPlay.append(selectedChords[3] + ".wav")
        }
        */
        
        if self.redButton.isTouchInside {
            if !self.flag1{
                self.guitar11!.playGuitar() //stop and play
                self.flag1 = true
            }
            else{
                self.guitar12!.playGuitar()
                self.flag1 = false
            }
        }
        
        if self.blueButton.isTouchInside {
            if !self.flag2{
                self.guitar21!.playGuitar()
                self.flag2 = true
            }
            else{
                self.guitar22!.playGuitar()
                self.flag2 = false
            }
        }
        
        if self.greenButton.isTouchInside {
            if !self.flag3{
                self.guitar31!.playGuitar()
                self.flag3 = true
            }
            else{
                self.guitar32!.playGuitar()
                self.flag3 = false
            }
        }
        
        if self.roseButton.isTouchInside {
            if !self.flag4{
                self.guitar41!.playGuitar()
                self.flag4 = true
            }
            else{
                self.guitar42!.playGuitar()
                self.flag4 = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let testUserDefault = userDefault.array(forKey: USER_DEFAULT_KEY_STRING) {
            var userData = testUserDefault as! Array<String>
            redButtonChord.text = userData[0]
            blueButtonChord.text = userData[1]
            greenButtonChord.text = userData[2]
            pinkButtonChord.text = userData[3]
        }
        
        else {
            let value = ["A","A","A","A"]
            userDefault.set(value, forKey: USER_DEFAULT_KEY_STRING)
            redButtonChord.text = "A"
            blueButtonChord.text = "A"
            greenButtonChord.text = "A"
            pinkButtonChord.text = "A"
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
        guard message["payload"] as! String == "1" else{
            print("Payload non è 1")
            return
        }
        play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
