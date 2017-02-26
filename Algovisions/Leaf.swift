import UIKit

class Leaf {
    var layer = CAShapeLayer()
    var value: Int
    let x: Double
    let y: Double
    
    init(x: Double, y: Double, radius: Double, value: Int) {
        self.value = value
        self.x = x
        self.y = y
        layer.path = UIBezierPath(
            arcCenter: CGPoint(x: x, y: y),
            radius: CGFloat(radius),
            startAngle: CGFloat(0),
            endAngle: CGFloat(360),
            clockwise: true
        ).cgPath
        layer.fillColor = UIColor.white.cgColor
    }
}
