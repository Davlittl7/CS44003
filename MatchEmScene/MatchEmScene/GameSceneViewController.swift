//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Guest User on 2/20/23.
//

import UIKit

// MARK: - ==== Config Properties ====
//================================================
// Min & max width and height for rectangles
private let rectSizeMin: CGFloat = 50.0
private let rectSizeMax: CGFloat = 150.0


class GameSceneViewController: UIViewController {

    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //================================================ 
    @objc private func handleTouch(sender: UIButton) {
        print("\(#function) - \(sender)")
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


// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
//================================================
    private func createRectangle() {
        // Get random values for size and location
        let randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
        
        // Creates a rectangle
        //let rectangleFrame = CGRect(x: 50, y: 150, width: 80, height: 40)
        let rectangle = UIButton(frame: randomFrame)
        
        //Button/rectangle setup
        rectangle.backgroundColor = .green
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

    }
}

