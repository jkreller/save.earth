import SpriteKit

enum ColliderType: UInt32 {
    case Collidable = 1
    case Movable = 2
}

public class Collidable {
    public var skNode: SKNode!

    public init(from: SKNode) {
        skNode = from

        // Setup physics body for collision detection with Movable
        skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.frame.size)
        skNode.physicsBody?.affectedByGravity = false
        skNode.physicsBody?.isDynamic = false
        skNode.physicsBody?.categoryBitMask = ColliderType.Collidable.rawValue
    }
}

public class Movable: Collidable {
    private var startPosition: CGPoint = CGPoint.zero
    private var hasDisabledMovement = false
    
    override public init(from: SKNode) {
        super.init(from: from)
        
        // Store start position for later
        startPosition = skNode.position
        
        // Override physics body for collision detection with Collidable
        skNode.physicsBody?.categoryBitMask = ColliderType.Movable.rawValue
        skNode.physicsBody?.collisionBitMask = ColliderType.Collidable.rawValue
        skNode.physicsBody?.contactTestBitMask = ColliderType.Collidable.rawValue
        skNode.physicsBody?.isDynamic = true
        skNode.physicsBody?.allowsRotation = false
    }
    
    public func moveTo(location: CGPoint) {
        if !hasDisabledMovement {
            skNode.position = CGPoint(x: location.x, y: location.y)
        }
    }
    
    public func resetPosition() {
        if !hasDisabledMovement {
            skNode.position = startPosition
        }
    }
    
    public func replaceWith(node: SKNode) {
        // Remove physics body that node can be replaced
        skNode.physicsBody = nil
        skNode.move(toParent: node.parent!)
        
        var nodePosition = node.position
        // If skNode is of class SKLabelNode move position to fit to it's center
        if (skNode as? SKLabelNode) != nil {
            nodePosition.y -= node.frame.size.height / 2
        }
        
        moveTo(location: nodePosition)
        hasDisabledMovement = true
        node.removeFromParent()
    }
}
