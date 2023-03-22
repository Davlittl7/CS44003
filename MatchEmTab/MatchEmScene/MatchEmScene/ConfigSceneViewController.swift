//
//  ConfigSceneViewController.swift
//  MatchEmScene
//
//  Created by Davonte Littleton on 3/17/23.
//

import UIKit

class ConfigSceneViewController: UIViewController {

    
    var matchSceneVC: GameSceneViewController?
    var firstPlace: Int = 0, secondPlace: Int = 0, thirdPlace: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        matchSceneVC = self.tabBarController!.viewControllers![0] as? GameSceneViewController
        rectIntervalSlider.value = 1.2
        intervalLabel.text = String(rectIntervalSlider.value)
        gameDurationLabel.text = "Game Duration: \(gameDurationSlider.value)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
        firstPlace = matchSceneVC?.highScores[2] ?? 0
        secondPlace = matchSceneVC?.highScores[1] ?? 0
        thirdPlace = matchSceneVC?.highScores[0] ?? 0
        
        highScoreLabel?.text = highScore
    }
    
    //Showcases the high scores of the match em game
    @IBOutlet weak var highScoreLabel: UILabel!
    private var highScore: String {
        let labelText = "High Scores:\n1. \(firstPlace) \n2. \(secondPlace) \n3. \(thirdPlace) "
        return labelText
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
