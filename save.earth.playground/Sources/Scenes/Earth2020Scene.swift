import SpriteKit

public class Earth2020Scene: SKScene, SaveEarthScene {
    public var runNextScene: ((_ choseSustainable: Bool?) -> Void)!
    private var title: SKNode!
    private var earthTitle: SKNode!
    private var earth: SKNode!
    private var wasTouched = false
    
    public override func didMove(to view: SKView) {
        // Get nodes from scene and store it for use later
        title = childNode(withName: "title")
        earthTitle = childNode(withName: "earthTitle")
        earth = childNode(withName: "earth")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !wasTouched {
            // Set wasTouched to true for running this code only once
            wasTouched = true
            
            // Set up actions
            let moveUpClose = SKAction.move(by: CGVector(dx: 0, dy: 700), duration: 0.9)
            moveUpClose.timingMode = .easeOut
            
            let moveUpFar = SKAction.move(by: CGVector(dx: 0, dy: 850), duration: 0.9)
            moveUpFar.timingMode = .easeOut
            
            let titleSequence = SKAction.sequence([.fadeOut(withDuration: 0.7), .wait(forDuration: 0.7)])
            let earthTitleSequence = SKAction.sequence([moveUpClose, .wait(forDuration: 1.5), .fadeOut(withDuration: 0.2)])
            let scaleAndFadeOut = SKAction.group([.scale(by: 20, duration: 0.5), .fadeOut(withDuration: 0.7)])
            let earthSequence = SKAction.sequence([moveUpFar, .wait(forDuration: 1.5), scaleAndFadeOut])
            
            // Run actions
            title.run(titleSequence) {
                self.earthTitle.run(earthTitleSequence)
                self.earth.run(earthSequence) {
                    self.runNextScene(nil)
                }
            }
        }
    }
}
