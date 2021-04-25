//
//  Top10ViewController.swift
//  FredGame
//
//  Created by user188455 on 3/15/21.
//

import UIKit

class Top10ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var scoreTableView: UITableView!
    var top10: Top10! = Top10()
    func configureView() {
        top10.loadData {
            DispatchQueue.main.async {
                self.scoreTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        scoreTableView.reloadData()
        print("Print from top10view ", top10data!.getList())
    }
    
    var top10data : Top10? {
        didSet {

        }
    }
    
   
    let dateForm = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dateForm.dateFormat = "yyyy-MM-dd"
        
        
        return cell
    }
}
