
import Foundation
import UIKit

class TextField : UITextField {
    let myWidth = UIElementsDefaultValues.longWidth
    let byHeight = UIElementsDefaultValues.buttonHegiht
    
    func defaultStyle() {
        self.defaultSize()
        self.defaultBackgroundColor()
    }
    
    func defaultSize() {
        self.widthLayoutAs(myWidth)
        self.heightLayoutAs(30)
    }
    
    func defaultBackgroundColor() {
        self.backgroundColor = UIColor.white
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

