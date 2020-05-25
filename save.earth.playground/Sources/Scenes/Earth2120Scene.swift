import SpriteKit

public class Earth2120Scene: SKScene, SaveEarthScene {
    public var runNextScene: ((_ choseSustainable: Bool?) -> Void)!
    public var madeSustainableChoices: Bool!
    private var earthHealthy: SKNode!
    private var earthUnhealthy: SKNode!
    private var resultTextSustainable: SKNode!
    private var resultTextNotSustainable: SKNode!

    public override func didMove(to view: SKView) {
        // Get nodes from scene and store it for use later
        earthHealthy = childNode(withName: "//earthHealthy")
        earthUnhealthy = childNode(withName: "//earthUnhealthy")
        resultTextSustainable = childNode(withName: "//resultTextSustainable")
        resultTextNotSustainable = childNode(withName: "//resultTextNotSustainable")
        
        // Remove not necessary earth according to made choices
        if madeSustainableChoices {
            earthUnhealthy?.removeFromParent()
            resultTextNotSustainable?.removeFromParent()
        } else {
            earthHealthy?.removeFromParent()
            resultTextSustainable?.removeFromParent()
        }
    }
}
