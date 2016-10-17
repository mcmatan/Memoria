//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

print("eweff")

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



class Draw: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        var color:UIColor = UIColor.yellow
        
        var drect = CGRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
        var bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
        print("it ran")
        
        NSLog("drawRect has updated the view")
        
    }
    
}

let k = Draw(frame: CGRect(
    origin: CGPoint(x: 50, y: 50),
    size: CGSize(width: 100, height: 100)))

// Add the view to the view hierarchy so that it shows up on screen
self.view.addSubview(k)

