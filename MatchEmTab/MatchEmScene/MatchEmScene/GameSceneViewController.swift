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
    private var newRectInterval: TimeInterval = 1.2
    // Rectangle creation, so the timer can be stopped
    private var newRectTimer: Timer?

    // Random transparency on or off
    private var randomAlpha = false
    
    var highScores = [0, 0, 0]

    
    //Button that functions as both a start and restart button
    @IBOutlet weak var sAndRButton: UIButton!
    @IBAction func sAndRButtonPressed(_ sender: UIButton) {
        startGameRunning();
        sAndRButton.isHidden = true
        //highScores.sort()
        print(highScores)
    }
    
    @IBOutlet weak var gameInfoLabel: UILabel!
    private var gameInfo: String {
        
        let labelText = "Pairs Created: \(rectPairsCreated) - Matches: \(rectPairsTouched) - Timer: \(gameTimeRemaining)"
        
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
    
    //Variables to keep track of the first button clicked
    private var isFirstClickedButton: Bool = true
    private var firstButtonClicked: UIButton?
    @objc private func handleTouch(sender: UIButton) {
        //Makes sure we can't click anything once the game is over
        if(gameInProgress == false) {
            return
        }
        
        //Checks for if it is the first button you clicked and saves it
        if(isFirstClickedButton) {
            sender.setTitle("😄", for: .normal)
            firstButtonClicked = sender
            isFirstClickedButton = false;
        //Checks to see if the second button you click matches the first one
        //If so, then both buttons are removed
        } else if (sender.backgroundColor == firstButtonClicked?.backgroundColor && sender.frame.size.height == firstButtonClicked?.frame.size.height && sender.frame.size.width == firstButtonClicked?.frame.size.width && sender != firstButtonClicked) {
            isFirstClickedButton = true
            sender.setTitle("😄", for: .normal)
            rectPairsTouched += 1
            removeRectangle(rectangle: sender)
            removeRectangle(rectangle: firstButtonClicked!)
        //If you don't match the colors, isFirstClickedButton is reset
        //And the rectangles are not removed
        } else {
            isFirstClickedButton = true
            firstButtonClicked?.setTitle("", for: .normal)
            print("Not a match!!")
        }
    }

    
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Starts running the game
        
        if(gameInProgress) {
            resumeGame()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (gameInProgress) {
            pauseGame()
        }
    }


}

// MARK: - ==== Internal Properties ====
// Keep track of all rectangles created
private var rectangles = [UIButton]()

// Game duration
private var gameDuration: TimeInterval = 13.0
// Game timer
private var gameTimer: Timer?




// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    
    private func createRectangle() -> UIButton {
   
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
        
        //Returns the rectangle so that we can assign it for
        //createPairOfRectangles later
        return rectangle

    }
    
    private func createPairOfRectangles() {
        //Decrement the game time
        gameTimeRemaining -= newRectInterval
        
        //Ensures that the app will show that they player has no time left
        if(gameTimeRemaining < newRectInterval) { gameTimeRemaining = 0.0 }
    
        //Creates two rectangles and set their color and size equal to each other
        let rectangleOne = createRectangle()
        let rectangleTwo = createRectangle()
        rectangleTwo.backgroundColor = rectangleOne.backgroundColor
        rectangleTwo.frame.size.width = rectangleOne.frame.size.width
        rectangleTwo.frame.size.height = rectangleOne.frame.size.height
        
        //Increment the amount of pairs created
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
    //================================================
    func removeSavedRectangles() {
        // Remove all rectangles from superview
        for rectangle in rectangles {
            rectangle.removeFromSuperview()
        }
        
        // Clear the rectangles array
        rectangles.removeAll()
    }

    private func startGameRunning() {
        //Removes all rectangles when game is restarted and sets up game
        highScores.sort()
        removeSavedRectangles()
        rectPairsCreated = 0 
        rectPairsTouched = 0 
        gameTimeRemaining = gameDuration
        
        // Init label colors
        gameInfoLabel.textColor = .black
        gameInfoLabel.backgroundColor = .clear
        
        gameInProgress = true
        //newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectangle()}
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createPairOfRectangles()}
        
       //Timer to end the game
       gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
            repeats: false) { _ in self.stopGameRunning() }
    }
    
    //================================================
    
    //Checks to see if new val for rectPairsTouched should be 
    //added into high score list
    private func updateHighScores() {
        for i in highScores.indices {
            if(highScores[i] < rectPairsTouched) {
                highScores[i] = rectPairsTouched
                return
            }
            
        }
        
    }
    
    //================================================
    private func stopGameRunning() {
        //Modify button, make it visible and bring it forward
        sAndRButton.isHidden = false
        sAndRButton.setTitle("Restart", for: .normal)
        view.bringSubviewToFront(sAndRButton)
        
        // Make the label stand out
        gameInfoLabel.textColor = .red
        gameInfoLabel.backgroundColor = .black
        
        gameInProgress = false
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        // Remove the reference to the timer object
        self.newRectTimer = nil
        updateHighScores();
    }
   
    //=================================================
    private func resumeGame() {
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createPairOfRectangles()}
        
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameTimeRemaining,
             repeats: false) { _ in self.stopGameRunning() }
    }
    
    public func pauseGame() {
        newRectTimer?.invalidate()
        gameTimer?.invalidate()
    
    }
}
