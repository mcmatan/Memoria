//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


let mirror = Mirror(reflecting: str)
let viewModelClassType = mirror.subjectType
let type = viewModelClassType.dynamicType
//let viewModel = self.container.resolve(viewModelClassType.self)

