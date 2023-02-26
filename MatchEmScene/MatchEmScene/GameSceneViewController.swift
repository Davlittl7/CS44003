//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Davonte Littleton on 2/20/23.
//

import UIKit

// MARK: - ==== Config Properties ====
//================================================
// Min & max width and height for rectangles
private let rectSizeMin: CGFloat = 50.0
private let rectSizeMax: CGFloat = 150.0
// How long for the rectangle to fade away
private var fadeDuration: TimeInterval = 0.8

class GameSceneViewController: UIViewController {
    //================================================
    override var prefersStatusBarHidden: Bool {
               return true
    }
    
    // Rectangle creation interval
    private var newRectInterval: TimeInterval = 0.6
    // Rectangle creation, so the timer can be stopped
    private var newRectTimer: Timer?

    // Random transparency on or off
    private var randomAlpha = false

    //Variables to keep track of the first button clicked 
    private var isFirstClickedButton: Bool = true
    private var firstButtonClicked: UIButton?
    
    @IBOutlet weak var gameInfoLabel: UILabel!
    private var gameInfo: String {
        
        let labelText = "Pairs Created: \(rectPairsCreated) - Matches Made: \(rectPairsTouched) - Time left: \(gameTimeRemaining)"
    
        // End of game, no time left, make sure label is updated
        //gameTimeRemaining = 0.0
        //gameInfoLabel?.text = gameInfo
        
        return labelText
    }
    
    
    // Counters, property observers used
    private var rectPairsCreated: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
    private var rectPairsTouched: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
    // Init the time remaining
    private var gameTimeRemaining = gameDuration {
        didSet { gameInfoLabel?.text = gameInfo }
    }
    
    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //================================================
    // A game is in progress
    private var gameInProgress = false
    
    @objc private func handleTouch(sender: UIButton) {
        
        if(gameInProgress == false) {
            return
        }
        
        //print("\(#function) - \(sender)")
        // Add emoji text to the rectangle
        sender.setTitle("😄", for: .normal)
        
      
        // Remove the rectangle
        removeRectangle(rectangle: sender)
        // Remove the final button owner
        sender.removeFromSuperview()
        rectPairsTouched += 1
    }

    
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Creates a rectangle 
        //createRectangle()
        //createRectangle()
        //createRectangle()
        startGameRunning()
    }


}

// MARK: - ==== Internal Properties ====
// Keep track of all rectangles created
private var rectangles = [UIButton]()

// Game duration
private var gameDuration: TimeInterval = 12.0
// Game timer
private var gameTimer: Timer?




// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    private func createRectangle() {
        //rectPairsCreated += 1
        
        // Decrement the game time remaining
        gameTimeRemaining -= newRectInterval
        if(gameTimeRemaining < newRectInterval) {
            gameTimeRemaining = 0.0
        }
        
        // Get random values for size and location
        let randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
        
        // Creates a rectangle
        //let rectangleFrame = CGRect(x: 50, y: 150, width: 80, height: 40)
        let rectangle = UIButton(frame: randomFrame)
        
        //Button/rectangle setup
        rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        rectangle.setTitle("", for: .normal)
        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle.showsTouchWhenHighlighted = true
        
        // Make the rectangle visible
        self.view.addSubview(rectangle)
        
        // Target/action to set up connect of button to the VC
        rectangle.addTarget(self,
                action: #selector(self.handleTouch(sender:)),
                for: .touchUpInside)
        // Save the rectangle till the game is over
        rectangles.append(rectangle)
        
        // Move label to the front
        view.bringSubviewToFront(gameInfoLabel!)

    }
    private func createPairOfRectangles() {
        rectangleOne = createRectangle()
        rectangleTwo = createRectangle()
        rectangleTwo.backgroundColor = rectangleOne.backgroundColor
        rectangleTwo.frame.size.width = rectangleOne.frame.size.width
        rectangleTwo.frame.size.height = rectangleTwo.frame.size.height
        rectPairsCreated += 1 
    }
    
    //================================================
    func removeRectangle(rectangle: UIButton) {
        // Rectangle fade animation
        let pa = UIViewPropertyAnimator(duration: fadeDuration,
        curve: .linear,
        animations: nil)
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        pa.startAnimation()
    }
}

extension GameSceneViewController {
    private func startGameRunning() {
        //Removes all rectangles when game is restarted
        removeSavedRectangles()
        
        // Init label colors
        gameInfoLabel.textColor = .black
        gameInfoLabel.backgroundColor = .clear
        
        //================================================
        func removeSavedRectangles() {
            // Remove all rectangles from superview
            for rectangle in rectangles {
                rectangle.removeFromSuperview()
            }
            
            // Clear the rectangles array
            rectangles.removeAll()
        }
        
        gameInProgress = true
        //newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectangle()}
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createPairOfRectangles()}
        
       //Timer to end the game
       gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
            repeats: false) { _ in self.stopGameRunning() }
    }
    //================================================
    private func stopGameRunning() {
        // Make the label stand out
        gameInfoLabel.textColor = .red
        gameInfoLabel.backgroundColor = .black
        
        gameInProgress = false
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.newRectTimer = nil
    }
}
