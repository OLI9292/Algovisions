// Code from from https://github.com/raywenderlich/swift-algorithm-club/blob/master/Binary%20Search%20Tree/Solution%201/BinarySearchTree.playground/Sources/BinarySearchTree.swift

/*
 A binary search tree.
 
 Each node stores a value and two children. The left child contains a smaller
 value; the right a larger (or equal) value.
 
 This tree allows duplicate elements.
 
 This tree does not automatically balance itself. To make sure it is balanced,
 you should insert new values in randomized order, not in sorted order.
 */
public class BinarySearchTree<T: Comparable> {
    fileprivate(set) public var value: T
    fileprivate(set) public var parent: BinarySearchTree?
    fileprivate(set) public var left: BinarySearchTree?
    fileprivate(set) public var right: BinarySearchTree?
    
    var steps = [Step]()
    
    public init(value: T) {
        self.value = value
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        steps.append(
            Step(value: value as! Int,
                 root: true,
                 insertingOnValue: nil,
                 direction: nil,
                 succesful: true,
                 level: self.level
            )
        )
        for v in array.dropFirst() {
            insert(value: v)
        }
    }
    
    public var root: BinarySearchTree {
        if let parent = parent { return parent.root }
        return self
    }
    
    public var level: Int {
        return 1 + (parent?.level ?? 0)
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    
    /* How many nodes are in this subtree. Performance: O(n). */
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
}

// MARK: - Adding items

extension BinarySearchTree {
    /*
     Inserts a new element into the tree. You should only insert elements
     at the root, to make to sure this remains a valid binary tree!
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func insert(value: T) {
        if value < self.value {
            if let left = left {
                root.steps.append(
                    Step(value: value as! Int,
                         root: false,
                         insertingOnValue: self.value as? Int,
                         direction: "left",
                         succesful: false,
                         level: self.level
                         
                    )
                )
                left.insert(value: value)
            } else {
                root.steps.append(
                    Step(value: value as! Int,
                         root: false,
                         insertingOnValue: self.value as? Int,
                         direction: "left",
                         succesful: true,
                         level: self.level
                    )
                )
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                root.steps.append(
                    Step(value: value as! Int,
                         root: false,
                         insertingOnValue: self.value as? Int,
                         direction: "right",
                         succesful: false,
                         level: self.level
                    )
                )
                right.insert(value: value)
            } else {
                root.steps.append(
                    Step(value: value as! Int,
                         root: false,
                         insertingOnValue: self.value as? Int,
                         direction: "right",
                         succesful: true,
                         level: self.level
                    )
                )
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }
}
