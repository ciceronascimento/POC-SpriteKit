//
//  GameScene.swift
//  POC-SpriteKit
//
//  Created by Cicero Nascimento on 27/03/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    let player = SKSpriteNode(imageNamed: "player")

    private var godofredo = SKSpriteNode()
    private var godofredoFrames: [SKTexture] = []

    
    override func didMove(to view: SKView) {

        view.showsPhysics = true



        let background = SKSpriteNode(imageNamed: "background")
        background.setScale(max(self.size.width / background.size.width, self.size.height / background.size.height))

        background.zPosition = -2
        addChild(background)


        physicsWorld.gravity = .zero
        player.position = CGPoint(x: size.width * -0.3, y: size.height * -0.1)
        addChild(player)
//        player.zPosition = -1
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = 0b0001
        player.physicsBody?.collisionBitMask = 0b0010
        player.physicsBody?.contactTestBitMask = 0b0010
//        player.physicsBody?.isDynamic = false

        buildGodofredo()
//        animateGodofredo()
        physicsWorld.contactDelegate = self
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 1.0)
                ])
            ))

    }

    func animateGodofredo() {
        godofredo.run(SKAction.repeatForever(SKAction.animate(with: godofredoFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walkingInPlaceGD")
    }

    func buildGodofredo() {
        let godofredoAtlas = SKTextureAtlas(named: "GodofredoImg")
        var walkFrames: [SKTexture] = []

        let numImages = godofredoAtlas.textureNames.count
        for i in 1...numImages {
            let godofredoTextureName = "gd\(i)"
            walkFrames.append(godofredoAtlas.textureNamed(godofredoTextureName))
        }
        godofredoFrames = walkFrames

        let firstFrameTexture = godofredoFrames[0]
        godofredo = SKSpriteNode(texture: firstFrameTexture)
        godofredo.size = CGSize(width: 50, height: 50)
        godofredo.position = CGPoint(x: frame.midX, y: frame.midY)
        godofredo.physicsBody = SKPhysicsBody(texture: godofredo.texture!, size: godofredo.size)
        godofredo.physicsBody?.allowsRotation = false
        addChild(godofredo)
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        //spawn inimigos atraves do Y axis
//        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
//
//        Aqui, self.frame.midY é a coordenada y central da cena e self.frame.height é a altura da cena. Usando esses valores, podemos calcular a posição y mínima e máxima que o inimigo pode ter:
//
//        O valor mínimo de actualY é definido como self.frame.midY - self.frame.height/2 + enemy.size.height/2. Isso é calculado subtraindo metade da altura da cena (self.frame.height/2) da coordenada y central da cena (self.frame.midY) e adicionando metade da altura do inimigo (enemy.size.height/2). Isso garantirá que o inimigo apareça apenas da metade da tela para baixo.

        let actualY = random(min: self.frame.midY - self.frame.height/2 + enemy.size.height/2, max: self.frame.midY - enemy.size.height/2)
        addChild(enemy)


//        enemy.zPosition = -1
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: actualY)
//        enemy.physicsBody?.usesPreciseCollisionDetection = true
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.collisionBitMask = 0b0010
        enemy.physicsBody?.contactTestBitMask = 0b0001
        enemy.physicsBody?.collisionBitMask = 0b0001

        self.physicsWorld.contactDelegate = self


        //velocidade
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(12.0))

        //posiçao eixo x
        let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width*20, y: actualY), duration: TimeInterval(actualDuration))

        //remove o nó
        let actionMoveDone = SKAction.removeFromParent()

        //aciona animação
        enemy.run(SKAction.sequence([actionMove, actionMoveDone]))

    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    func godofredoMoveEnd() {
        godofredo.removeAllActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)

//            let actionMoveVertical = SKAction.moveTo(y: location.y, duration: 1)
//            player.run(actionMoveVertical)

//            print(location)
            let actionMove = SKAction.moveTo(x: location.x, duration: 1)
            let actionMove2 = SKAction.moveTo(y: location.y, duration: 1)

            player.run(SKAction.sequence([actionMove, actionMove2]))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//
//        var multiplierForDirection: CGFloat
//        if location.x < frame.midX {
//            //andar pra esquerda
//            multiplierForDirection = -1.0
//        } else {
//            multiplierForDirection = 1.0
//        }
//
//        godofredo.xScale = abs(godofredo.xScale) * multiplierForDirection
//        animateGodofredo()

        let touch = touches.first!
        let location = touch.location(in: self)
        moveGodofredo(location: location)
    }

    func moveGodofredo(location: CGPoint) {
        var multiplierForDirection: CGFloat
        let godofredoSpeed = frame.size.width / 3.0
        let moveDifference = CGPoint(x: location.x - godofredo.position.x, y: location.y - godofredo.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)

        let moveDuration = distanceToMove / godofredoSpeed

        if moveDifference.x < 0 {
            multiplierForDirection = -1.0
        } else {
            multiplierForDirection = 1.0
        }
        godofredo.xScale = abs(godofredo.xScale) * multiplierForDirection

        if godofredo.action(forKey: "walkingInPlaceGD") == nil {
            animateGodofredo()
        }

        let moveAction = SKAction.move(to: location, duration: (TimeInterval(moveDuration)))

        let doneAction = SKAction.run({ [weak self] in
            self?.godofredoMoveEnd()
        })

        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        godofredo.run(moveActionWithDone, withKey: "godofredoMovendo")
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("A:", contact.bodyA.node?.name ?? "no node")
        print("B:", contact.bodyB.node?.name ?? "no node")
    }
}
