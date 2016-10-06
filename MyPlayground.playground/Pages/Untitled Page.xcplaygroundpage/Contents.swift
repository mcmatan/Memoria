//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

class SomeObject {
    var someValue = ""
}

class ClassA {
    var someObject : SomeObject!
}


class ClassB {
    var someObject : SomeObject!
}


let mirror = Mirror(reflecting: str)
let viewModelClassType = mirror.subjectType
let type = viewModelClassType.dynamicType
//let viewModel = self.container.resolve(viewModelClassType.self)

var myObject = SomeObject()
myObject.someValue = "12"

var classA = ClassA()
classA.someObject = myObject

print(classA.someObject.someValue)

myObject.someValue = "13"

print(classA.someObject.someValue)

