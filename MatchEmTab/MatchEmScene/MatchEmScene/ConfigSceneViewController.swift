//
//  ConfigSceneViewController.swift
//  MatchEmScene
//
//  Created by Davonte Littleton on 3/17/23.
//

import UIKit

class ConfigSceneViewController: UIViewController, UITableViewDelegate{
 
    

    @IBOutlet weak var highScoreTableView: UITableView!
    
    
    var matchSceneVC: GameSceneViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Adds connectivity to game scene
        matchSceneVC = self.tabBarController!.viewControllers![0] as? GameSceneViewController
        
        rectIntervalSlider.value = 1.2
        intervalLabel.text = String(rectIntervalSlider.value)
        gameDurationLabel.text = "Game Duration: \(gameDurationSlider.value)"
        
        //Setting up Table View
        highScoreTableView.delegate = self
        highScoreTableView.dataSource = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //Makes sure that the high scores are up to date when view appears
        highScoreTableView.reloadData()
        
    }

    
    //Affects the time in which rectangles appear
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var rectIntervalSlider: UISlider!
    @IBAction func rectIntervalChange(_ sender: UISlider) {
        intervalLabel.text = String(rectIntervalSlider.value)
        matchSceneVC?.newRectInterval = TimeInterval(1.2 / rectIntervalSlider.value)
    }
    
    //Changes the background color of match game scene
    @IBAction func lightOrDarkMode(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            matchSceneVC?.view.backgroundColor = .white
        } else if (sender.selectedSegmentIndex == 1) {
            matchSceneVC?.view.backgroundColor = .gray
        }
        else {
            matchSceneVC?.view.backgroundColor = .yellow
        }
    }
    
    //Modifies values of game Duration
    @IBOutlet weak var gameDurationLabel: UILabel!
    @IBOutlet weak var gameDurationSlider: UISlider!
    @IBAction func gameDurationChange(_ sender: Any) {
        gameDurationLabel.text = "Game Duration: \(gameDurationSlider.value)"
        gameDuration = TimeInterval(gameDurationSlider.value)
    }
    
  
    //Code for changing the rectangles from random colors to all blue ones
    @IBOutlet weak var randOrBlueLabel: UILabel!
    @IBOutlet weak var randOrBlueSwitch: UISwitch!
    @IBAction func randOrBlueOnOrOff(_ sender: UISwitch) {
        if(sender.isOn) {
            for rectangle in rectangles {
                rectangle.backgroundColor = .blue
            }
            randOrBlueLabel.text = "Currently all Blue Rects!"
        } else {
            for rectangle in rectangles {
                rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: true)
            }
            randOrBlueLabel.text = "Currently all Rainbow Rects!"
        }
    }
    
    
    

}


extension ConfigSceneViewController: UITableViewDataSource {
    
    //Makes sure that there are 3 rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    //Puts in the new highscores from the matching game
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1). \(matchSceneVC?.highScores[indexPath.row] ?? 0)"
        return cell
    }
    

}
