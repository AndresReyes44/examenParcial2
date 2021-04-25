//
//  ViewController.swift
//  FredGame
//
//  Created by user188455 on 3/14/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: Variables
    let generator : SequenceGenerator = SequenceGenerator()
    let top10 : Top10 = Top10()
    var buttonsGrid : [UIButton?] = [UIButton?](repeating : nil, count: 10)
    var sequenceList : [Int] = []
    var pressedButtonCounter : Int = 0
    var score : Int = 0
    var username = "NONAME"

    // MARK: Outlets
    @IBOutlet weak var play: UIBarButtonItem!
    @IBOutlet weak var scores: UIBarButtonItem!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    
    @IBOutlet weak var pendingCounter: UILabel!
    @IBOutlet weak var turnIndicator: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeButtonsGrid()
        disableGameButtons()
        enableActionButtons()
        play.isEnabled = true
        scores.isEnabled = true
        Dbop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(fetchData() == "EMPTY"){
            requestNickname()
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            saveData(UserDBObj:newUser)
        }
    }
  
    // MARK: Variables declarations
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
    
    
    
        func Dbop()
        {
            context = appDelegate.persistentContainer.viewContext
        }

        func saveData(UserDBObj:NSManagedObject)
        {
            UserDBObj.setValue(username, forKey: "username")

            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }
        }

        func fetchData() -> String
        {
            print("Fetching Data..")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                if(result.isEmpty){
                    return "EMPTY"
                }else{
                    for data in result as! [NSManagedObject] {
                        
                    }
                }
    
            return "f"
        }
    
    
    
    // MARK: Actions
    @IBAction func startGame(_ sender: Any) {
        status.text = "🤔"
        playRound(roundNumber: 1)
        score = 0
        scoreLabel.text = "0"
    }
    
    @IBAction func userResponse(_ sender: UIButton) {
        let pressedButtonIndex = buttonsGrid.firstIndex(of: sender)
        let currentPendingCounter = Int(self.pendingCounter.text!)
        let newPendingCounter = currentPendingCounter! - 1
        pendingCounter.text = String(newPendingCounter)
        
        sender.alpha = 1
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
            sender.alpha = 0.5
        }
               
        if sequenceList[pressedButtonCounter] == pressedButtonIndex {
            score = score + Int(pressedButtonCounter + 1) * 100
            scoreLabel.text = String(score)
            print(score)
            
            if pressedButtonCounter == sequenceList.count - 1 {
                pressedButtonCounter = 0
                
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (nil) in
                    self.playRound(roundNumber: self.sequenceList.count + 1)
                }
            } else {
                pressedButtonCounter = pressedButtonCounter + 1
            }
        } else {
            pressedButtonCounter = 0
            status.text = "😱"
            pendingCounter.text = "0"
            top10.add(newScore: Score(name: username, date: Date(), points: score))
            enableActionButtons()
            disableGameButtons()
            
            let alertController = UIAlertController(title: "Game Status", message: "GAME OVER", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
            
            print(top10.getList())
        }
        
        
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTopScores" {
            let controller = (segue.destination as! Top10ViewController)
            controller.top10data = top10
        }
    }
    
    // MARK: Game Methods
    func playRound(roundNumber : Int) {
        disableGameButtons()
        disableActionButtons()
        sequenceList = generator.getSequenceList(size: roundNumber)
        turnIndicator.text = "Fred"
        pendingCounter.text = String(roundNumber)
        processSequenceButton(sequenceList : sequenceList, index : 0)
    }
    
    func processSequenceButton(sequenceList : [Int], index : Int) {
        let sequenceNumber : Int = sequenceList[index]
        let button : UIButton = buttonsGrid[sequenceNumber]!
        button.alpha = 1
       
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
            button.alpha = 0.5
            let currentPendingCounter = Int(self.pendingCounter.text!)
            let newPendingCounter = currentPendingCounter! - 1
            self.pendingCounter.text = String(newPendingCounter)
            
            if index < sequenceList.count - 1 {
                self.processSequenceButton(sequenceList: sequenceList, index: index + 1)
            } else {
                self.enableGameButtons()
                self.disableActionButtons()
                self.turnIndicator.text = self.username
                self.pendingCounter.text = String(sequenceList.count)
            }
        }
    }
    
    func requestNickname() {
        let alertController = UIAlertController(title: "Nickname needed", message: "Please provide a nickname", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField() {
            (nicknameTextfield) in
            nicknameTextfield.placeholder = "Type your nickname here"
        }
        let ignoreAction = UIAlertAction(title: "Ignore", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(ignoreAction)
        let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
            (action) in
            let textFields = alertController.textFields
            let nicknameTextfield = textFields?.first
            self.username = nicknameTextfield?.text! ?? "NONAME"
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: self.context)
            let newUser = NSManagedObject(entity: entity!, insertInto: self.context)
            self.saveData(UserDBObj:newUser)
        }
        alertController.addAction(doneAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UI Methods
    func initializeButtonsGrid() {
        buttonsGrid.insert(button1, at: 1)
        buttonsGrid.insert(button2, at: 2)
        buttonsGrid.insert(button3, at: 3)
        buttonsGrid.insert(button4, at: 4)
        buttonsGrid.insert(button5, at: 5)
        buttonsGrid.insert(button6, at: 6)
        buttonsGrid.insert(button7, at: 7)
        buttonsGrid.insert(button8, at: 8)
        buttonsGrid.insert(button9, at: 9)
    }
    
    func disableGameButtons() {
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        button4.isEnabled = false
        button5.isEnabled = false
        button6.isEnabled = false
        button7.isEnabled = false
        button8.isEnabled = false
        button9.isEnabled = false
        button1.isEnabled = false
        button1.isEnabled = false
    }
    
    func enableGameButtons() {
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        button4.isEnabled = true
        button5.isEnabled = true
        button6.isEnabled = true
        button7.isEnabled = true
        button8.isEnabled = true
        button9.isEnabled = true
        button1.isEnabled = true
        button1.isEnabled = true
    }
    
    func disableActionButtons() {
        play.isEnabled = false
        scores.isEnabled = false
    }
    
    func enableActionButtons() {
        play.isEnabled = true
        scores.isEnabled = true
    }

}

