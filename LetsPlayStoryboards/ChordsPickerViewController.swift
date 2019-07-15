//
//  ChordsPickerViewController.swift
//  LetsPlayStoryboards
//
//  Created by Christian Marino on 15/07/2019.
//  Copyright © 2019 Christian Marino. All rights reserved.
//

import UIKit

class ChordsPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    //Datasource per i picker
    
    let chords = ["A", "Am", "B", "Bm", "C","Cm","D","Dm","E","Em","F","Fm", "G", "Gm"];
    let userDefaults = UserDefaults.standard
    let USER_DEFAULT_KEY = "chords"
    var userData = Array<Int>()
    
    @IBOutlet var chordPickers: [UIPickerView]!
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()

        
        
        //Applico lo stile ad ogni bottone
        for b in buttons{
            b.layer.frame = CGRect(x: 30.51, y: 583.67, width: 153.02, height: 47);
        
            b.layer.backgroundColor = UIColor(red: 0.28, green: 0.32, blue: 0.37, alpha: 1).cgColor;
            
            b.layer.cornerRadius = 8;
         
        }
    
        
        for p in chordPickers{
            
            p.dataSource = self;
            p.delegate = self;
            
            p.layer.frame = CGRect(x: 183.83, y: 217.17, width: 78, height: 265.67)
            p.layer.backgroundColor = UIColor(red: 0.2, green: 0.25, blue: 0.29, alpha: 1).cgColor;
            p.layer.borderWidth = 0.3333333333333333
            p.layer.borderColor = UIColor(red: 0.75, green: 0.8, blue: 0.85, alpha: 1).cgColor
            //p.selectRow con usersetting
            //p.selectRow(2, inComponent: 0, animated: true);
            
        }
        
        let testUserData = userDefaults.array(forKey: USER_DEFAULT_KEY)
        guard testUserData != nil else {
            print("No data")
            lastusedButton.isEnabled = false;
            return
        }
        
        self.userData = testUserData as! [Int]
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

       
        var color: UIColor!
      
        color = UIColor.orange;
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color
//        NSFontAttributeName.rawValue: UIFont.systemFontOfSize(15)
        ]
        
        return NSAttributedString(string: chords[row%chords.count], attributes: attributes);
    }
    
 



func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    pickerView.view(forRow: row, forComponent: component)?.backgroundColor = UIColor.green;
    pickerView.reloadAllComponents()
}
/*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = chords[row%chords.count];
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
        
        return myTitle;
        
    }
 
 */
 
    @IBOutlet var buttons: [UIButton]!;
    @IBOutlet var lastusedButton: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loopMargin*chords.count;
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chords[row%chords.count];
   }
    
    
    let loopMargin = 50;
    
    
    @IBAction func confirmButton(_ sender: Any) {
        
        var valuesToStore = Array <Int>(repeating: 0, count: 4)
        var j = 0
        for pick in chordPickers {
            valuesToStore[j] = pick.selectedRow(inComponent: 0)
            j += 1
        }
        userDefaults.set(valuesToStore, forKey: USER_DEFAULT_KEY)
        lastusedButton.isEnabled = true;
        print(valuesToStore)
    }
    
    @IBAction func lastUsedBotton(_ sender: Any) {
        var valuesRead = self.userData
        var i = 0
        for pick in chordPickers {
            pick.selectRow(valuesRead[i%chords.count], inComponent: 0, animated: true)
            i += 1
        }
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