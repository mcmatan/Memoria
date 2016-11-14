
import Foundation
import UIKit

class TextField : UITextField {
    let myWidth = UIElementsDefaultValues.longWidth
    let byHeight = UIElementsDefaultValues.buttonHegiht
    
    func defaultStyle() {
        self.defaultSize()
        self.defaultBackgroundColor()
        self.defaultCornerRaduis()
    }
    
    func defaultSize() {
        self.setWidthAs(myWidth)
        self.setHeightAs(self.byHeight)
    }
    
    func defaultBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func defaultBackgroundColor() {
        self.backgroundColor = UIColor.white
    }
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8);
    
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

