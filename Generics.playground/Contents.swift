/*
 MARK: GENERICS
 enables you to write flexible, reusable functions and types that can work with any type
*/

// MARK: Generic Functions
// MARK: T is a Type Parameter (T, U, V)

// MARK: solution without Generics
// with inout you can change a parameter value, becase by default they are constants
// with this solution, the function only accepts Int as parameters
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// MARK: solution with Generics
// with this solution, the function accepts any type
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// MARK: Sample use
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt) and anotherInt is \(anotherInt)")

var someDouble = 3.3
var anotherDouble = 107.7
swapTwoValues(&someDouble, &anotherDouble)
print("someDouble is now \(someDouble) and anotherDouble is \(anotherDouble)")

var someString = "Hello"
var anotherString = "World"
swapTwoValues(&someString, &anotherString)
print("someString is now \(someString) and anotherString is \(anotherString)")


// MARK: Generic Types

// Non generic stack
struct IntStack {
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// Generic Stack
struct Stack<T> {
    var items = [T]()
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
}

// MARK: Sample use
var stackOfInts = IntStack()
stackOfInts.push(3)
stackOfInts.push(2)
stackOfInts.push(1)
print(stackOfInts)

var stackOfStrings = Stack<String>()
stackOfStrings.push("World")
stackOfStrings.push("Hello")
print(stackOfStrings)

var stackOfDoubles = Stack<Double>()
stackOfDoubles.push(3.5)
stackOfDoubles.push(2.5)
stackOfDoubles.push(1.5)
print(stackOfDoubles)

// MARK: Extending a Generic Type
extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

print("The top item from stackOfDoubles is \(stackOfDoubles.topItem ?? 0)")

// MARK: Type Constraints
// Type Constraints specify that a type parameter must inherit from a specific class or protocol
func someFunction<T: AnyObject, U: AnyObject>(someT: T, someU: U) { }

// nongeneric type constraint function
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}

// generic type constraint function
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let ints = [111, 222, 333, 444, 555]
if let foundIndex = findIndex(of: 444, in: ints) {
    print("The index of 444 is \(foundIndex)")
}

// MARK: Associated Type
// gives a placeholder name to a type
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// nongeneric
struct IntContainer: Container {
    typealias Item = Int
    
    var items = [Item]()
    
    mutating func append(_ item: Item) {
        items.append(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Item {
        return items[i]
    }
}

//with generic
struct StackContainer<T>: Container {
    typealias Item = T
    
    var items = [T]()
    
    mutating func append(_ item: T) {
        items.append(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> T {
        return items[i]
    }
}

// MARK: Adding contraint to an Associated Type
protocol AnotherContainer {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

protocol SuffixableContainer: AnotherContainer {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

// MARK: Extensions with a Generic Where Clause
extension Stack where T: Equatable {
    func isTop(_ item: T) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings.isTop("Hello") {
    print("Top element is Hello")
} else {
    print("Top element is something else ")
}
