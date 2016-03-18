
import Foundation
import UIKit

extension UIView {

    func addSubviewWithAutoLayoutOn(subview : UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
    func addSubviewsWithAutoLayoutOn(subviews : [UIView]) {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    func centerInSuperView() {
        self.centerHorizontalyInSuperView()
        self.centerVerticlyInSuperView()
    }
    
    func centerHorizontalyInSuperView()->NSLayoutConstraint { //Y
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        superview?.addConstraint(constraint)
        return constraint
    }
    
    func centerVerticlyInSuperView()->NSLayoutConstraint { //X
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        superview?.addConstraint(constraint)
        return constraint
    }

    func topToViewControllerTopLayoutGuide(viewControlelr : UIViewController) {
        self.topToViewControllerTopLayoutGuide(viewControlelr, offset: 0)
    }

    func topToViewControllerTopLayoutGuide(viewControlelr : UIViewController, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topLayoutGuide = viewControlelr.topLayoutGuide
        let matrics : [String : AnyObject] =
        [
            "offset" : offset
        ]
        let views : [String : AnyObject] =
        [
            "me" : self,
            "topLayoutGuide" : topLayoutGuide
        ]
        var allConstrains = [NSLayoutConstraint]()
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topLayoutGuide]-(offset)-[me]"
            , options: [], metrics: matrics, views: views)
        allConstrains += verticalLayout
        NSLayoutConstraint.activateConstraints(allConstrains)
    }

    
    func bottomToViewControllerTopLayoutGuide(viewControlelr : UIViewController) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let bottomLayoutGuide = viewControlelr.bottomLayoutGuide
        let views : [String : AnyObject] =
        [
            "me" : self,
            "bottomLayoutGuide" : bottomLayoutGuide
        ]
        var allConstrains = [NSLayoutConstraint]()
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[me]-[bottomLayoutGuide]"
            , options: [], metrics: nil, views: views)
        allConstrains += verticalLayout
        NSLayoutConstraint.activateConstraints(allConstrains)
    }
    
    func heightLayoutAs(height : Double)->NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CGFloat(height))
        NSLayoutConstraint.activateConstraints([contrain])
        return contrain
    }
    func widthLayoutAs(width : Double)->NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CGFloat(width))
        NSLayoutConstraint.activateConstraints([contrain])
        return contrain
    }

    func topAlighnToViewTop(view : UIView)->NSLayoutConstraint {
        return self.topAlighnToViewTop(view, offset: 0)
    }
    
    func topAlighnToViewTop(view : UIView, offset : CGFloat)->NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activateConstraints([contrain])
        return contrain
    }

    func topAlighnToViewBottom(view : UIView) {
        return self.topAlighnToViewBottom(view, offset: 0)
    }
    
    func topAlighnToViewBottom(view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activateConstraints([contrain])
    }

    //MARK: Bottom
    
    func bottomAlighnToViewBottom(view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activateConstraints([contrain])
    }

    
    func trailingToSuperView(withMargin : Bool) {
        var att = NSLayoutAttribute.Trailing
        att = withMargin ?  NSLayoutAttribute.TrailingMargin : NSLayoutAttribute.Trailing
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([contrain])
    }
    func leadingToSuperView(withMargin : Bool) {
        var att = NSLayoutAttribute.Leading
        att = withMargin ?  NSLayoutAttribute.LeadingMargin : NSLayoutAttribute.Leading
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([contrain])
    }
    func clipToWidthSuperView() {
        let viewsKeys : [String : AnyObject] =
        [
            "me" : self,
            "superView" : self.superview!
        ]
        let constrain = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[me]|", options: [], metrics: nil, views: viewsKeys)
        NSLayoutConstraint.activateConstraints(constrain)
    }

}

class UIViewAutoLayoutExtentions {
    class func centerVerticlyAlViewsInSuperView(views : [UIView]) {
        for view in views {
            view.centerVerticlyInSuperView()
        }
    }
    class func centerHorizontalyAlViewsInSuperView(views : [UIView]) {
        for view in views {
            view.centerHorizontalyInSuperView()
        }
    }
    class func equalHegihtForViews(views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
                if let isLastView = firstView {
                    let contraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: isLastView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0)
                    NSLayoutConstraint.activateConstraints([contraint])
                } else {
                    firstView = currentView
                }
        }
    }
    class func equalWidthsForViews(views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
            if let isFirstView = firstView {
                NSLayoutConstraint(item: currentView, attribute: .Width, relatedBy: .Equal, toItem: isFirstView, attribute:.Width, multiplier: 1.0, constant:0.0).active = true
            } else {
                firstView = currentView
            }
        }
    }
    class func equalHeightsForViews(views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
            if let isFirstView = firstView {
                NSLayoutConstraint(item: currentView, attribute: .Height, relatedBy: .Equal, toItem: isFirstView, attribute:.Height, multiplier: 1.0, constant:0.0).active = true
            } else {
                firstView = currentView
            }
        }
    }

}
