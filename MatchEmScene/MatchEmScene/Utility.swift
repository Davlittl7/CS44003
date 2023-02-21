//Created by Davonte Littleton


import UIKit

class Utility: NSObject {
  let ri = Int.random(in: 0 ... 99)
  let rd = Double.random(in: 0.0 ... 1.0)
  // MARK: - ==== Random Value Funcs ====
  //================================================
  static func randomFloatZeroThroughOne() -> CGFloat {
    // Get a random value
    let randomFloat = CGFloat.random(in: 0 ... 1.0)
    return randomFloat
  }
  
  //================================================
  static func getRandomSize(fromMin min: CGFloat,
  throughMax max: CGFloat) -> CGSize {
    // Create a random CGSize
    let randWidth = randomFloatZeroThroughOne() * (max - min) + min
    let randHeight = randomFloatZeroThroughOne() * (max - min) + min
    let randSize = CGSize(width: randWidth, height: randHeight)
    return randSize
  }
  
  //================================================
  static func getRandomLocation(size rectSize: CGSize,
  screenSize: CGSize) -> CGPoint {
    // Get the screen dimensions
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    // Create a random location/point
    let rectX = randomFloatZeroThroughOne() * (screenWidth - rectSize.width)
    let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
    let location = CGPoint(x: rectX, y: rectY)
    return location
  }

}
