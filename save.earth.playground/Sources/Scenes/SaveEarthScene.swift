import SpriteKit

public protocol SaveEarthScene: SKScene {
    var runNextScene: ((_ choseSustainable: Bool?) -> Void)! { get set }
}
