import Foundation
import UIKit


class ButtonAction : NSObject {
    var title: String
    var handler : ((ButtonAction!) -> Void)!
    init(title: String, handler: ((ButtonAction!) -> Void)!) {
        self.title = title
        self.handler = handler
    }
}


class PopUpPresenter : NSObject{
    
    func presentPopUp(title : String, message : String , cancelButton : ButtonAction! , buttons : [ButtonAction]! , completion : (() -> Void)? ){
        let view = UIApplication.sharedApplication().keyWindow?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if let isButtons = buttons {
            for buttonAction in isButtons {
                alert.addAction(UIAlertAction(title: buttonAction.title, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    buttonAction.handler(buttonAction)
                }))
            }
        }
        
        if let isCancelButton = cancelButton {
            alert.addAction(UIAlertAction(title: isCancelButton.title, style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                isCancelButton.handler(isCancelButton)
            }))
        }
        
        view!.presentViewController(alert, animated: true, completion: completion)
    }
}