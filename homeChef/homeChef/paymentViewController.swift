//
//  paymentViewController.swift
//  homeChef
//
//  Created by amit kumar on 11/30/17.
//  Copyright © 2017 amit kumar. All rights reserved.
//

import UIKit

class paymentViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var card: UITextField!
    
    @IBOutlet weak var card_number: UITextField!
    
    @IBOutlet weak var valid: UITextField!
    
    @IBOutlet weak var cvv: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(card.text, forKey: "name")
        defaults.set(card_number.text, forKey: "number")
        defaults.set(valid.text, forKey: "valid")
        defaults.set(cvv.text, forKey: "cvv")
        defaults.set(Date(), forKey: "LastRun")
    }
    
    func fetchInfo() {
        card.text = UserDefaults.standard.string(forKey: "name")
        card_number.text = UserDefaults.standard.string(forKey: "number")
        valid.text = UserDefaults.standard.string(forKey: "valid")
        cvv.text = UserDefaults.standard.string(forKey: "cvv")
    }
    
    @IBAction func clear(_ sender: Any) {
        card.text = ""
        card_number.text = ""
        valid.text = ""
        cvv.text = ""
    }
    
}
