//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

// Setup counters
var sceneCount = 0
var codeBlockSceneCount = 0
var sustainableChoiceCount = 0

// Setup scene view
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

// Start first scene
runNextScene()

func runNextScene(choseSustainable: Bool? = nil) {
    // If user chose sustainable option in the previous scene, increment counter
    if choseSustainable != nil && choseSustainable! {
        sustainableChoiceCount += 1
    }
    
    var scene: SaveEarthScene!
    
    // Load scene according to scene counter
    switch sceneCount {
    case 0:
        scene = Earth2020Scene(fileNamed: "Scenes/Earth2020Scene")!
        break;
    case 1:
        scene = CodeBlockScene(fileNamed: "Scenes/CityScene")!
        break
    case 2:
        scene = CodeBlockScene(fileNamed: "Scenes/HomeScene")!
        break;
    case 3:
        scene = CodeBlockScene(fileNamed: "Scenes/EnergySourceScene")!
        break;
    default:
        let earth2120Scene = Earth2120Scene(fileNamed: "Scenes/Earth2120Scene")!
        earth2120Scene.madeSustainableChoices = sustainableChoiceCount > Int(codeBlockSceneCount / 2)
        scene = earth2120Scene as SaveEarthScene
    }

    // Set runNextScene function for current scene
    scene.runNextScene = runNextScene

    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present scene with transition
    let transition: SKTransition = SKTransition.fade(withDuration: 1)
    sceneView.presentScene(scene, transition: transition)
    
    // Increment counters for scene selection and result logic
    sceneCount += 1
    if let _ = scene as? CodeBlockScene {
        codeBlockSceneCount += 1
    }
}

// Set playground view to scene view
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
