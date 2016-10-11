import Foundation
import UIKit


class ButtonAction : NSObject {
    var title: String
    var handler : ((ButtonAction?) -> Void)!
    init(title: String, handler: ((ButtonAction?) -> Void)!) {
        self.title = title
        self.handler = handler
    }
}


class ReminderPopUp : NSObject{
    var isPresented = false
    
    func presentPopUp(_ title : String, message : String , cancelButton : ButtonAction! , buttons : [ButtonAction]! , completion : (() -> Void)? ){
        self.isPresented = true
        let view = UIApplication.shared.keyWindow?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let isButtons = buttons {
            for buttonAction in isButtons {
                alert.addAction(UIAlertAction(title: buttonAction.title, style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    buttonAction.handler(buttonAction)
                    self.isPresented = false
                }))
            }
        }
        
        if let isCancelButton = cancelButton {
            alert.addAction(UIAlertAction(title: isCancelButton.title, style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                isCancelButton.handler(isCancelButton)
                self.isPresented = false
            }))
        }

        
        view!.present(alert, animated: true, completion: completion)
        
    }
}
