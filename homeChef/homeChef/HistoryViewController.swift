//
//  HistoryViewController.swift
//  homeChef
//
//  Created by amit kumar on 11/30/17.
//  Copyright © 2017 amit kumar. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var imageMenuData: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageMenuData = ["Sashimi Salad             $7.99",
                         "Sanraku Salad             $5.99",
                         "Green Salad               $12.29",
                         "Clam Miso Soup            $11.99",
                         "Akadashi                  $8.99"]
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = imageMenuData[indexPath.row]
        print(imageMenuData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderVC") as! OrderViewController
        self.present(vc, animated: true, completion: nil)
    }

}
