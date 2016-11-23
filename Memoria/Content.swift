import Foundation

@objc enum ContentType : Int {
    case buttonTxt
    case warningTxt
    case alertTxt
    case toolTipTxt
    case labelTxt
}

class Content : NSObject {
    
    
    @objc class func getContent(_ contentType : ContentType , name : String)->String  {
        
        var path : String!
        switch contentType {
        case ContentType.buttonTxt:
            path = Bundle.main.path(forResource: "ButtonsTexts", ofType: "plist") as String!
        case ContentType.toolTipTxt:
            path = Bundle.main.path(forResource: "ToolTipsPlist", ofType: "plist") as String!
        case ContentType.warningTxt:
            path = Bundle.main.path(forResource: "WarningsTxts", ofType: "plist") as String!
        case ContentType.alertTxt:
            path = Bundle.main.path(forResource: "AlertsTxts", ofType: "plist") as String!
        case ContentType.labelTxt:
            path = Bundle.main.path(forResource: "LabelsTexts", ofType: "plist") as String!
        }
        
        if let _ = path {
            let dic : NSDictionary = NSDictionary(contentsOfFile: path)!
            
            if let value: AnyObject = dic.value(forKey: name) as AnyObject? {
                if let isString = value as? String {
                    return isString
                }
            }
        }
        
        NSException(name: NSExceptionName(rawValue: "Content cant find request for contnt"), reason: "Content cant find request for type \(contentType) name \(name)", userInfo: nil)
        
        return ""
    }
    
    @objc class func getContent(name : String)->String  {
        return self.getContent(ContentType.labelTxt, name: name)
    }
    
}
