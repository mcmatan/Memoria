import Foundation

@objc enum ContentType : Int {
    case ButtonTxt
    case WarningTxt
    case AlertTxt
    case ToolTipTxt
    case LabelTxt
}

class Content : NSObject {
    
    
    @objc class func getContent(contentType : ContentType , name : String)->String  {
        
        var path : String!
        switch contentType {
        case ContentType.ButtonTxt:
            path = NSBundle.mainBundle().pathForResource("ButtonsTexts", ofType: "plist") as String!
        case ContentType.ToolTipTxt:
            path = NSBundle.mainBundle().pathForResource("ToolTipsPlist", ofType: "plist") as String!
        case ContentType.WarningTxt:
            path = NSBundle.mainBundle().pathForResource("WarningsTxts", ofType: "plist") as String!
        case ContentType.AlertTxt:
            path = NSBundle.mainBundle().pathForResource("AlertsTxts", ofType: "plist") as String!
        case ContentType.LabelTxt:
            path = NSBundle.mainBundle().pathForResource("LabelsTexts", ofType: "plist") as String!
        }
        
        if let _ = path {
            let dic : NSDictionary = NSDictionary(contentsOfFile: path)!
            
            if let value: AnyObject = dic[name] {
                if let isString = value as? String {
                    
                    let finalString = isString.stringByReplacingOccurrencesOfString("Stox", withString: "GetStocks")
                    return finalString
                }
            }
        }
        
        NSException(name: "Content cant find request for contnt", reason: "Content cant find request for type \(contentType) name \(name)", userInfo: nil)
        
        return ""
    }
    
}