
import Foundation
import UIKit
import SnapKit

class Button : UIButton {
    var myDefaultWidth = Double(UIScreen.mainScreen().bounds.size.width) - 40.0
    var myDefaultHeight = 50.0
    
    var colorFlicker = UIColor.redColor()
    var flickerTimer : NSTimer?
    
    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultStyle() {
        self.defaultSize()
        self.defaultColor()
        self.defaultCornerRaduis()
    }
    
    func defaultStyleMini() {
        self.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.defaultColor()
        self.defaultCornerRaduis()
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    func defaultSize() {
        self.defaultHeight()
        self.defaultWidth()
    }
    
    func defaultHeight() {
        self.heightLayoutAs(myDefaultHeight)
    }
    
    func defaultWidth() {
        self.widthLayoutAs(myDefaultWidth)
    }
    
    func defaultColor() {
        self.backgroundColor = UIColor(rgba: "#6d9de0")
    }
    
    func defaultCornerRaduis() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 4.0
    }
    
    func defaultBigButton() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 3.0
        self.widthLayoutAs(242)
        self.heightLayoutAs(44)
        let font = Fonts.defaultBigButtonFont()
        self.titleLabel?.font = font
    }
    
    internal func editBtn() {
        self.setBackgroundImage(UIImage(named: "EditBtn"), forState: UIControlState.Normal)
        self.widthLayoutAs(67)
        self.heightLayoutAs(30)
    }
    
    internal func playSoundBtn() {
        self.setBackgroundImage(UIImage(named: "PlaySoundBtn"), forState: UIControlState.Normal)
        self.widthLayoutAs(136)
        self.heightLayoutAs(32)
    }
    
    internal func notificiationPlaySoundBtn() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.ButtonTxt, name: "PlaySound"), forState: UIControlState.Normal)
    }
    
    internal func notificiationOkThanksBtn() {
        self.backgroundColor = Colors.lightGray()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.ButtonTxt, name: "OkThanks"), forState: UIControlState.Normal)
    }

    internal func notificiationRemindMeLater() {
        self.backgroundColor = Colors.lightGray()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.ButtonTxt, name: "RemingMeLater"), forState: UIControlState.Normal)
    }

    internal func notificiationYesVericiation() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.ButtonTxt, name: "Yes"), forState: UIControlState.Normal)
    }

    internal func notificiationThankYou() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.ButtonTxt, name: "NotificationThankYou"), forState: UIControlState.Normal)
    }
    
    internal func notificiationPlayingGray() {
        self.setBackgroundImage(UIImage(named: "BtnSoundPlayingGrayNotification"), forState: UIControlState.Normal)
        self.widthLayoutAs(165)
        self.heightLayoutAs(22)
    }


    
    deinit {
        if let _ = self.flickerTimer {
            self.stopFlickerRedColor()
        }
    }
    
    
    //MARK : color flicker
    func startFlickeringRedColor() {
        self.flickerTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(Button.tickRedColor), userInfo: nil, repeats: true)
    }
    
    func stopFlickerRedColor() {
        if let _ = self.flickerTimer {
            self.flickerTimer!.invalidate()
            self.flickerTimer = nil
        }
    }
    
    func tickRedColor() {
        if (self.backgroundColor == UIColor.redColor()) {
            self.defaultColor()
        } else { self.backgroundColor = UIColor.redColor() }
    }
}