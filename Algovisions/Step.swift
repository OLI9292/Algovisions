import UIKit

struct Step {
    let value: Int
    let root: Bool
    let insertingOnValue: Int?
    let direction: String?
    let succesful: Bool
    let level: Int
    
    var description: String? {
        if root { return "Use \(value) as root." }
        if let direction = direction, let insertingOnValue = insertingOnValue  {
            return "Attempt to insert \(value) to the \(direction) of \(insertingOnValue)."
        }
        return nil
    }
    
    var successDescription: String? {
        if root { return nil }
        if succesful {
            return "Success!"
        } else if let direction = direction, let insertingOnValue = insertingOnValue {
            return "\(insertingOnValue) already has a leaf to it's \(direction)."
        }
        return nil
    }
    
    var successColor: UIColor {
        return succesful ?
            UIColor(red: 0.02, green: 0.48, blue: 0.12, alpha: 1.0) :
            UIColor(red: 0.71, green: 0.07, blue: 0.07, alpha: 1.0)
    }
}
