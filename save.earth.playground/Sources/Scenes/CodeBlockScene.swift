import SpriteKit

public class CodeBlockScene: SKScene, SKPhysicsContactDelegate, SaveEarthScene {
    public var runNextScene: ((_ choseSustainable: Bool?) -> Void)!
    var codeBlock: SKNode!
    var codeBlockPlaceholder: Collidable!
    var codeSustainable: Movable!
    var codeNotSustainable: Movable!
    var touchOffset = CGVector.zero
    var currentMovableNode: Movable?
    var movableNodes: [Movable] = []
    
    override public func didMove(to view: SKView) {
        // Get nodes from scene and store it for use later
        codeBlock = childNode(withName: "codeBlock")
        codeBlockPlaceholder = Collidable(from: codeBlock.childNode(withName: "placeholder")!)
        codeSustainable = Movable(from: childNode(withName: "codeSustainable")!)
        codeNotSustainable = Movable(from: childNode(withName: "codeNotSustainable")!)

        // Set nodes which are movable and set it up as a movable node
        movableNodes = [codeSustainable, codeNotSustainable]

        // Show codeBlock
        let codeBlockHeight = codeBlock.childNode(withName: "background")!.frame.size.height
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: codeBlockHeight), duration: 0.5)
        moveUp.timingMode = .easeOut
        codeBlock.run(.sequence([.wait(forDuration: 1), moveUp]))

        // Setup contact delegate
        physicsWorld.contactDelegate = self
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // If movable node is touched, set offset between touch and node center and set currentMovableNode
            handleMovableTouched(touch: touch) { movableNode in
                touchOffset = touch.location(in: self).vectorTo(other: movableNode.skNode.position)
                currentMovableNode = movableNode
            }
        }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Move currentMovableNode with touch
            let touchLocation = touch.location(in: self)
            currentMovableNode?.moveTo(location: CGPoint(x: touchLocation.x + touchOffset.dx, y: touchLocation.y + touchOffset.dy))
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset currentMovableNode
        currentMovableNode?.resetPosition()
        currentMovableNode = nil
    }

    public func didBegin(_ contact: SKPhysicsContact) {
        // If currentMovableNode contacts with codeBlockPlaceholder or other way around replace movable node with placeholder and run next scene after 0.5 seconds
        let movableContactsPlaceholder = contact.bodyA.node?.name == codeBlockPlaceholder.skNode.name && contact.bodyB.node?.name == currentMovableNode?.skNode.name
        let placeholderContactsMovable = contact.bodyA.node?.name == currentMovableNode?.skNode.name && contact.bodyB.node?.name == codeBlockPlaceholder.skNode.name
        if placeholderContactsMovable || movableContactsPlaceholder {
            currentMovableNode?.replaceWith(node: codeBlockPlaceholder.skNode)
            let chosenNode = currentMovableNode?.skNode
            run(.wait(forDuration: 0.5)) {
                self.runNextScene(chosenNode?.name == self.codeSustainable?.skNode.name)
            }
        }
    }

    // Function for executing code if movable node is dragged
    func handleMovableTouched(touch: UITouch, code: (Movable) -> Void) {
        for movableNode in movableNodes {
            if movableNode.skNode.contains(touch.location(in: self)) {
                code(movableNode)
            }
        }
    }
}
