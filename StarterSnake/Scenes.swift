import SpriteKit

enum Direction {
    case Right
    case Left
    case Up
    case Down
}

class GameScene: SKScene {
    
    var snakeSegments = [SKSpriteNode]()
    var food = SKSpriteNode(imageNamed: "food")
    var lastTouch : UITouch? = nil
    var currentDirection = Direction.Right
    
    func updateDirection() {
        if let t = lastTouch {
            let head = snakeSegments.first!.position
            let loc = convertPointFromView(t.locationInView(self.view!))
            switch currentDirection {
            case .Left, .Right:
                currentDirection = loc.y > head.y ? .Up : .Down
            case .Up, .Down:
                currentDirection = loc.x > head.x ? .Right : .Left
            }
        }
    }
    
    func move() {
        let first = snakeSegments.first!
        var newPos = first.position
        switch currentDirection {
        case .Right:
            newPos.x += first.size.width
        case .Left:
            newPos.x -= first.size.width
        case .Up:
            newPos.y += first.size.height
        case .Down:
            newPos.y -= first.size.height
        }
        let newSeg = SKSpriteNode(imageNamed: "snakebody")
        newSeg.position = newPos
        snakeSegments.insert(newSeg, atIndex: 0)
        addChild(newSeg)
        if !snakeGrew {
            let lastSeg = snakeSegments.popLast()!
            lastSeg.removeFromParent()
        }
        
    }
    
    func foodEaten() -> Bool {
        return CGRectIntersectsRect(food.frame, snakeSegments.first!.frame)
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func moveFood() {
        let x = randomBetweenNumbers(0, secondNum: size.width - food.size.width)
        let y = randomBetweenNumbers(0, secondNum: size.height - food.size.height)
        food.position = CGPoint(x: x, y: y)
    }
    
    
    func gameOver() -> Bool {
         // HACKERS IMPLEMENT THIS
        return false
    }
    
    func moveToGameOverScene() {
        // HACKERS IMPLEMENT THIS
    }
    
    var snakeGrew = false
    
    func update() {
        updateDirection()
        if foodEaten() {
            moveFood()
            snakeGrew = true
        }
        move()
        snakeGrew = false
        if gameOver() {
            moveToGameOverScene()
        }
        lastTouch = nil
       
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastTouch = touches.first
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        snakeSegments.append(SKSpriteNode(imageNamed: "snakebody"))
        snakeSegments.first!.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(snakeSegments.first!)
        
        addChild(food)
        moveFood()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(update),
                SKAction.waitForDuration(0.3)
            ])
        ))
    }

}