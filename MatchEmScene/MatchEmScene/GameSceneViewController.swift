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
    
    // Random transparency on or off
    private var randomAlpha = false


    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //================================================ 
    @objc private func handleTouch(sender: UIButton) {
        //print("\(#function) - \(sender)")
        // Add emoji text to the rectangle
        //sender.setTitle("😄", for: .normal)
        // Remove the rectangle
        removeRectangle(rectangle: sender)
        // Remove the final button owner
        sender.removeFromSuperview()
        rectanglesTouched += 1
    }

    
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Creates a rectangle 
        createRectangle()
        createRectangle()
        createRectangle()
    }


}

// MARK: - ==== Internal Properties ====
// Keep track of all rectangles created
private var rectangles = [UIButton]()

// Rectangle creation interval
private var newRectInterval: TimeInterval = 1.2
// Rectangle creation, so the timer can be stopped
private var newRectTimer: Timer?

//Counters
private var rectanglesCreated = 0
private var rectanglesTouched = 0

// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    private func createRectangle() {
        rectanglesCreated += 1
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
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectangle()}
    }
}
