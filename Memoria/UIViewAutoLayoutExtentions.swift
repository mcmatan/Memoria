
import Foundation
import UIKit

extension UIView {

    func addSubviewWithAutoLayoutOn(_ subview : UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
    func addSubviewsWithAutoLayoutOn(_ subviews : [UIView]) {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    func centerInSuperView() {
        self.centerVerticlyInSuperView()
        self.centerHorizontlyInSuperView()
    }
    
    func centerVerticlyInSuperView() { //Y
        self.centerVerticlyInSuperView(offset:0)
    }
    
    func centerVerticlyInSuperView(offset: CGFloat) { //Y
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: offset)
        superview?.addConstraint(constraint)
    }
    
    func centerHorizontlyInSuperView() { //X
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        superview?.addConstraint(constraint)
    }

    func topToViewControllerTopLayoutGuide(_ viewControlelr : UIViewController) {
        self.topToViewControllerTopLayoutGuide(viewControlelr, offset: 0)
    }

    func topToViewControllerTopLayoutGuide(_ viewControlelr : UIViewController, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topLayoutGuide = viewControlelr.topLayoutGuide
        let matrics : [String : AnyObject] =
        [
            "offset" : offset as AnyObject
        ]
        let views : [String : AnyObject] =
        [
            "me" : self,
            "topLayoutGuide" : topLayoutGuide
        ]
        var allConstrains = [NSLayoutConstraint]()
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-(offset)-[me]"
            , options: [], metrics: matrics, views: views)
        allConstrains += verticalLayout
        NSLayoutConstraint.activate(allConstrains)
    }

    
    func bottomToViewControllerTopLayoutGuide(_ viewControlelr : UIViewController) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let bottomLayoutGuide = viewControlelr.bottomLayoutGuide
        let views : [String : AnyObject] =
        [
            "me" : self,
            "bottomLayoutGuide" : bottomLayoutGuide
        ]
        var allConstrains = [NSLayoutConstraint]()
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[me]-[bottomLayoutGuide]"
            , options: [], metrics: nil, views: views)
        allConstrains += verticalLayout
        NSLayoutConstraint.activate(allConstrains)
    }
    
    func setHeightAs(_ height : Double) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: CGFloat(height))
        NSLayoutConstraint.activate([contrain])
    }
    
    //MARK: Width
    func setWidthAs(_ width : Double) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: CGFloat(width))
        NSLayoutConstraint.activate([contrain])
    }
    
    func widthAsViewHeight(viewHeight: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: viewHeight, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contrain])
    }

    func topAlighnToViewTop(_ view : UIView){
        self.topAlighnToViewTop(view, offset: 0)
    }
    
    func topAlighnToViewTop(_ view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }

    func topAlighnToViewBottom(_ view : UIView) {
        return self.topAlighnToViewBottom(view, offset: 0)
    }
    
    func topAlighnToViewBottom(_ view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }

    //MARK: Bottom
    
    func bottomAlighnToViewBottom(_ view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }
    
    func bottomAlighnToViewTop(_ view : UIView, offset : CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }
    
    func bottomAlighnToViewBottom(_ view : UIView) {
        self.bottomAlighnToViewBottom(view,offset: 0)
    }
    
    func trailingToSuperView(_ withMargin : Bool) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        var att = NSLayoutAttribute.trailing
        att = withMargin ?  NSLayoutAttribute.trailingMargin : NSLayoutAttribute.trailing
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contrain])
    }
    
    //MARK: Leading
    func leadingToSuperView(_ withMargin : Bool) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        var att = NSLayoutAttribute.leading
        att = withMargin ?  NSLayoutAttribute.leadingMargin : NSLayoutAttribute.leading
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contrain])
    }
    
    func leadingToViewTrailing(view: UIView, offset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }
    
    func leadingToViewLeading(view: UIView, offset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([contrain])
    }
    
    func topToSuperView(_ withMargin : Bool) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        var att = NSLayoutAttribute.top
        att = withMargin ?  NSLayoutAttribute.topMargin : NSLayoutAttribute.top
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contrain])
    }
    
    func bottomToSuperView(_ withMargin : Bool) {
        self.translatesAutoresizingMaskIntoConstraints =  false
        var att = NSLayoutAttribute.bottom
        att = withMargin ?  NSLayoutAttribute.bottomMargin : NSLayoutAttribute.bottom
        let contrain =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: att, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contrain])
    }
    
    func clipToWidthSuperView() {
        let viewsKeys : [String : AnyObject] =
        [
            "me" : self,
            "superView" : self.superview!
        ]
        let constrain = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[me]|", options: [], metrics: nil, views: viewsKeys)
        NSLayoutConstraint.activate(constrain)
    }

    //MARK: Edges
    
    func edgesToSuperView(withPadding: Bool) {
        self.leadingToSuperView(withPadding)
        self.trailingToSuperView(withPadding)
        self.topToSuperView(withPadding)
        self.bottomToSuperView(withPadding)
    }
}

class UIViewAutoLayoutExtentions {
    class func centerVerticlyAlViewsInSuperView(_ views : [UIView]) {
        for view in views {
            view.centerHorizontlyInSuperView()
        }
    }
    class func centerVerticalyAlViewsInSuperView(_ views : [UIView]) {
        for view in views {
            view.centerVerticlyInSuperView()
        }
    }
    class func equalHegihtForViews(_ views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
                if let isLastView = firstView {
                    let contraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: isLastView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0)
                    NSLayoutConstraint.activate([contraint])
                } else {
                    firstView = currentView
                }
        }
    }
    class func equalWidthsForViews(_ views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
            if let isFirstView = firstView {
                NSLayoutConstraint(item: currentView, attribute: .width, relatedBy: .equal, toItem: isFirstView, attribute:.width, multiplier: 1.0, constant:0.0).isActive = true
            } else {
                firstView = currentView
            }
        }
    }
    class func equalHeightsForViews(_ views : [UIView]) {
        var firstView : UIView?
        for currentView in views {
            if let isFirstView = firstView {
                NSLayoutConstraint(item: currentView, attribute: .height, relatedBy: .equal, toItem: isFirstView, attribute:.height, multiplier: 1.0, constant:0.0).isActive = true
            } else {
                firstView = currentView
            }
        }
    }

}
