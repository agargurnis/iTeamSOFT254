//
//  PasscodeViewController.swift
//  TicketMachine
//
//  Created by Arvids Gargurnis on 09/04/2017.
//  Copyright © 2017 Arvids Gargurnis. All rights reserved.
//

import UIKit
import CloudKit

class PasscodeViewController: UIViewController {

    var sessionPass = Int()
    var username = String()
    var userID = String()
    var sessionID = Int()
    var sessionName = String()
    
    var keypadPasswordArray = [Int]()
    
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var okLbl: UIButton!
    @IBOutlet weak var clearLbl: UIButton!
    
    @IBAction func btn1(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(1);
        }
        passwordFieldChecker()
    }
    @IBAction func btn2(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(2);
        }
        passwordFieldChecker()
    }
    @IBAction func btn3(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(3);
        }
        passwordFieldChecker()
    }
    @IBAction func btn4(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(4);
        }
        passwordFieldChecker()
    }
    @IBAction func btn5(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(5);
        }
        passwordFieldChecker()
    }
    @IBAction func btn6(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(6);
        }
        passwordFieldChecker()
    }
    @IBAction func btn7(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(7);
        }
        passwordFieldChecker()
    }
    @IBAction func btn8(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(8);
        }
        passwordFieldChecker()
    }
    @IBAction func btn9(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(9);
        }
        passwordFieldChecker()
    }
    @IBAction func btn0(_ sender: Any) {
        if(keypadPasswordArray.count != 4){
            keypadPasswordArray.append(0);
        }
        passwordFieldChecker()
    }
    @IBAction func okBtn(_ sender: Any) {
        var passString = ""
        _ = keypadPasswordArray.map{ passString = passString + "\($0)" }
        let userPass = Int(passString)

        if(sessionPass == userPass){
            performSegue(withIdentifier: "toSessionView", sender: self)
        } else {
            keypadPasswordArray.removeAll()
            passwordLbl.text = ""
            clearLbl.isEnabled = false
            okLbl.isEnabled = false
        }
    }
    @IBAction func clearBtn(_ sender: Any) {
        keypadPasswordArray.removeAll()
        passwordLbl.text = ""
        clearLbl.isEnabled = false
        okLbl.isEnabled = false
    }
    
    func passwordFieldChecker(){
        if(keypadPasswordArray.count == 1){
            passwordLbl.text = "*"
        } else if (keypadPasswordArray.count == 2){
            passwordLbl.text = "**"
        } else if (keypadPasswordArray.count == 3){
            passwordLbl.text = "***"
        } else if (keypadPasswordArray.count == 4){
            passwordLbl.text = "****"
            okLbl.isEnabled = true
        }
        clearLbl.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLbl.text = ""
        clearLbl.isEnabled = false
        okLbl.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSessionView" {
            if let destinationController = segue.destination as? SessionViewController {
                destinationController.username = username
                destinationController.userID = userID
                destinationController.sessionID = sessionID
                destinationController.sessionName = sessionName
            }
        }
    }

}
