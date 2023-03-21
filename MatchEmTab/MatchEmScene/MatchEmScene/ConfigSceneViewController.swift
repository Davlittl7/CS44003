//
//  ConfigSceneViewController.swift
//  MatchEmScene
//
//  Created by Davonte Littleton on 3/17/23.
//

import UIKit

class ConfigSceneViewController: UIViewController {

    var matchSceneVC: GameSceneViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        matchSceneVC = self.tabBarController!.viewControllers![0] as? GameSceneViewController
    }
    
    @IBOutlet weak var highScoreLabel: UILabel!
    private var highScore: String {
        let labelText = "1. \(firstPlace) \n 2. \(secondPlace) \n 3. \(thirdPlace) "
        return labelText
    }
    
    private var firstPlace: Int = matchSceneVC?.highScores[2] {
        didSet { highScoreLabel?.text = highScore } }
    private var secondPlace: Int = matchSceneVC?.highScores[1] {
        didSet { highScoreLabel?.text = highScore } }
    private var thirdPlace: Int = matchSceneVC?.highScores[0] {
        didSet { highScoreLabel?.text = highScore } }
    
    /*
    private var matchScenceVC?.highScores[2]: Int = 0 {
        didSet { highScoreLabel?.text = highScore } }
    private var matchSceneVC?.highScores[1]: Int = 0 {
        didSet { highScoreLabel?.text = highScore } }
    private var matchSceneVC?.highScores[0]: Int = 0 {
        didSet { highScoreLabel?.text = highScore } }
    
    
    private var matchSceneVC?.highScores: Array<Int> = [0, 0, 0] {
        didSet { highScoreLabel?.text = highScore } }
    */ 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
