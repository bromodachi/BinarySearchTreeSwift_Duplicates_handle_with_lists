//: Playground - noun: a place where people can play

import UIKit

///A photo to a gear. This hold the order(file_id) and the photo_id to the server(_id)
///It also holds the url given from the server


///Credit goes to the amazing functional swift book. Edited to allow duplicates
indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf
    case Node(BinarySearchTree<Element>, [Element], BinarySearchTree<Element>)
}

extension BinarySearchTree {
    init () {
        self = .Leaf
    }
    init (_ value: Element) {
        self = .Node(.Leaf, [value], .Leaf)
    }
    var count: Int {
        switch self { case .Leaf:
            return 0
        case let .Node(left, _, right ):
            return 1 + left.count + right.count }
    }
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right ):
            return left .elements + x + right.elements }
    }
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension BinarySearchTree {
    mutating func insert(x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y.first! { left.insert(x: x) }
            if x > y.first! { right.insert(x: x) }
            var y = y
            if let elementX = x as? Element,
                let elementY = y.first {
                if elementX == elementY {
                    y.append(x)
                }
            }
            self = .Node(left, y, right)
        }
    }
}
func +<G: IteratorProtocol, H:IteratorProtocol> (first: G, second: H) -> AnyIterator<G.Element> where G.Element == H.Element  {
    var first = first
    var second = second
    return AnyIterator {first.next() ?? second.next() }
}

func one<T>(x: [T]?) -> AnyIterator<T> {
    if let x = x {
        var test = AnyIterator<T>{ return nil }
        for value in x {
            test = test + AnyIterator(IteratorOverOne(_elements: value))
        }
        return test
    }
    return AnyIterator{ return nil }
}
extension BinarySearchTree {
    var inOrder: AnyIterator<Element> {
        switch self {
        case .Leaf:
            return AnyIterator{ return nil }
        case .Node(let left, let x, let right):
            return left.inOrder + one(x: x) + right.inOrder
        }
    }
}

extension BinarySearchTree {
    
    func getMinValue(_ root: BinarySearchTree<Element>) ->  [Element] {
        var curr: [Element]!
        var currNode = root
        var bool = true
        while bool {
            switch currNode {
                case .Node(var left, let element, var right):
                    curr = element
                    bool = !whileNoNull(left).isEmpty
                    if bool {
                        currNode = left
                    }
            default:
                bool = false
            }
        }
        return curr
    }
    func whileNoNull(_ root: BinarySearchTree<Element>)->  BinarySearchTree<Element>{
        switch root {
        case .Leaf : return root
        case .Node(let left, _, _):
            return left
        }
    }
    mutating func delete(key: Element)->  BinarySearchTree<Element> {
        switch self {
        case .Leaf: return self
        case .Node(var left, let element, var right):
            if key < element.first! {  self = .Node(left.delete(key: key), element, right) }
            else if key > element.first! { self = .Node(left, element, right.delete(key: key)) }
            else {
                if left.isEmpty {
                    return right
                }
                else if right.isEmpty {
                    return left
                }
                //in case of two children
                let newKey = getMinValue(right)
                self = .Node(left, newKey, right.delete(key: newKey.first!))
            }
        }
        return self
    }
}


var intBinary = BinarySearchTree<Int>()

intBinary.insert(x: 5)
intBinary.insert(x: 3)
intBinary.insert(x: 7)
intBinary.insert(x: 10)
intBinary.insert(x: 1)
intBinary.insert(x: 2)
intBinary.insert(x: 15)
intBinary.insert(x: 15)



var iterator = intBinary.inOrder
while let value = iterator.next() {
    print(value)
}
print("count: \(intBinary.count)")
intBinary.delete(key: 5)
intBinary.delete(key: 50)
intBinary.delete(key: 15)
iterator = intBinary.inOrder
while let value = iterator.next() {
    print(value)
}
