import SpriteKit

public extension CGPoint {
    func vectorTo(other: CGPoint) -> CGVector {
        return CGVector(dx: other.x - self.x, dy: other.y - self.y)
    }
}
