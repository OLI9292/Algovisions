//
//  ViewController.swift
//  Algovisions
//
//  Created by Oliver  on 2/25/17.
//  Copyright © 2017 Oliver . All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    
    var tree: BinarySearchTree<Int>?
    var leaves = [Leaf]()
    
    var steps = [Step]()
    
    let LINE_DISTANCE: Double = 120
    let CIRCLE_RADIUS: Double = 15
    
    var distFromOrigin: Double {
        return CIRCLE_RADIUS / sqrt(2)
    }
    
    var screenWidth: Double {
        return Double(self.view.frame.size.width)
    }
    
    var screenHeight: Double {
        return Double(self.view.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tree = BinarySearchTree(array: [10,8,14,3,9,1,7,29,21,11])
        
        guard let stepsCount = tree?.steps.count else { return }
        for i in 0..<stepsCount {
            delay(i * 2) {
                guard let step = self.tree?.steps[i] else { return }
                self.visualize(step)
            }
        }
    }
    
    func visualize(_ step: Step) {
        stepLabel.text = step.description
        successLabel.text = step.successDescription
        successLabel.textColor = step.successColor
        
        if step.root { insertRoot(step.value) }
        
        insert(step)
    }
    
    func insertRoot(_ value: Int) {
        let pointX = screenWidth/2
        let pointY = screenHeight/8
        let leaf = Leaf(x: pointX, y: pointY, radius: CIRCLE_RADIUS, value: value)
        leaf.layer.strokeColor = UIColor.black.cgColor
        leaves.append(leaf)
        view.layer.addSublayer(leaf.layer)
        
        addLeafLabel(x: pointX, y: pointY, value: value)
    }
    
    func insert(_ step: Step) {
        guard let insertingOnLeaf = leaves.filter({ $0.value == step.insertingOnValue }).first else { return }
        let x = getXPoints(insertingOnLeaf: insertingOnLeaf, direction: step.direction, level: step.level)
        let y = getYPoints(insertingOnLeaf: insertingOnLeaf, level: step.level)
        let start = CGPoint(x: x.start, y: y.start)
        let end = CGPoint(x: x.end, y: y.end)
        let line = addLine(fromPoint: start, toPoint: end)
        
        if step.succesful {
            addLeaf(step, insertingOnLeaf: insertingOnLeaf)
        } else {
            line.strokeColor = UIColor.black.cgColor
        }
    }
}

// MARK: - UI
extension ViewController {
    func addLine(fromPoint start: CGPoint, toPoint end: CGPoint) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.black.cgColor
        view.layer.addSublayer(line)
        return line
    }
    
    func addLeaf(_ step: Step, insertingOnLeaf: Leaf) {
        let points = getXYPoints(insertingOnLeaf: insertingOnLeaf, direction: step.direction, level: step.level)
        let leaf = Leaf(x: points.x, y: points.y, radius: CIRCLE_RADIUS, value: step.value)
        leaf.layer.strokeColor = UIColor.black.cgColor
        leaves.append(leaf)
        view.layer.addSublayer(leaf.layer)
        
        addLeafLabel(x: points.x, y: points.y, value: step.value)
    }
    
    func addLeafLabel(x: Double, y: Double, value: Int) {
        let frameX = x - CIRCLE_RADIUS
        let frameY = y - CIRCLE_RADIUS
        let length = CIRCLE_RADIUS * 2
        let label = UILabel(frame: CGRect(x: frameX, y: frameY, width: length, height: length))
        label.text = String(value)
        label.textAlignment = .center
        label.textColor = .black
        view.addSubview(label)
    }
}

// MARK: - Positions
extension ViewController {
    func getXPoints(insertingOnLeaf: Leaf, direction: String?, level: Int) -> (start: Double, end: Double) {
        let lineDistance = distFromParent(level: level)
        let start = direction == "left" ? insertingOnLeaf.x - distFromOrigin : insertingOnLeaf.x + distFromOrigin
        let end = direction == "left" ? start - lineDistance : start + lineDistance
        return (start, end)
    }
    
    func getYPoints(insertingOnLeaf: Leaf, level: Int) -> (start: Double, end: Double) {
        let lineDistance = distFromParent(level: level)
        let start = insertingOnLeaf.y + distFromOrigin
        let end = start + lineDistance
        return (start, end)
    }
    
    func getXYPoints(insertingOnLeaf: Leaf, direction: String?, level: Int) -> (x: Double, y: Double) {
        let lineDistance = distFromParent(level: level)
        let distance = lineDistance + (2 * distFromOrigin)
        let x = direction == "left" ? insertingOnLeaf.x - distance : insertingOnLeaf.x + distance
        let y = insertingOnLeaf.y + distance
        return (x, y)
    }
    
    func distFromParent(level: Int) -> Double {
        return LINE_DISTANCE * pow(0.5, Double(level))
    }
}

// MARK: - Helpers
extension ViewController {
    func delay(_ delay: Int, closure: @escaping ()->()) {
        let when = DispatchTime.now() + Double(delay)
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
