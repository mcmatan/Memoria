
import Foundation
import UIKit
import SnapKit

class Button : UIButton {
    var myDefaultWidth = UIElementsDefaultValues.longWidth
    var myDefaultHeight = UIElementsDefaultValues.buttonHegiht
    
    var colorFlicker = UIColor.red
    var flickerTimer : Timer?
    
    init() {
        super.init(frame: CGRect.zero)
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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.defaultColor()
        self.defaultCornerRaduis()
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    func defaultSize() {
        self.defaultHeight()
        self.defaultWidth()
    }
    
    func defaultHeight() {
        self.setHeightAs(Double(myDefaultHeight))
    }
    
    func defaultWidth() {
        self.setWidthAs(myDefaultWidth)
    }
    
    func defaultColor() {
        self.backgroundColor = Colors.blue()
    }
    
    func defaultCornerRaduis() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 4.0
    }
    
    func defaultBigButton() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 3.0
        self.setWidthAs(242)
        self.setHeightAs(44)
        let font = Fonts.defaultBigButtonFont()
        self.titleLabel?.font = font
    }
    
    internal func editBtn() {
        self.setBackgroundImage(UIImage(named: "EditBtn"), for: UIControlState())
        self.setWidthAs(67)
        self.setHeightAs(30)
    }
    
    internal func playSoundBtn() {
        self.setBackgroundImage(UIImage(named: "PlaySoundBtn"), for: UIControlState())
        self.setWidthAs(136)
        self.setHeightAs(32)
    }
    
    internal func notificiationPlaySoundBtn() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.buttonTxt, name: "PlaySound"), for: UIControlState())
    }
    
    internal func notificiationOkThanksBtn() {
        self.backgroundColor = Colors.lightBlue()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.buttonTxt, name: "OkThanks"), for: UIControlState())
    }

    internal func notificiationRemindMeLater() {
        self.backgroundColor = Colors.lightBlue()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.buttonTxt, name: "RemingMeLater"), for: UIControlState())
    }

    internal func notificiationYesVericiation() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.buttonTxt, name: "Yes"), for: UIControlState())
    }

    internal func notificiationThankYou() {
        self.backgroundColor = Colors.green()
        self.defaultBigButton()
        self.setTitle(Content.getContent(ContentType.buttonTxt, name: "NotificationThankYou"), for: UIControlState())
    }
    
    internal func notificiationPlayingGray() {
        self.setBackgroundImage(UIImage(named: "BtnSoundPlayingGrayNotification"), for: UIControlState())
        self.setWidthAs(165)
        self.setHeightAs(22)
    }


    
    deinit {
        if let _ = self.flickerTimer {
            self.stopFlickerRedColor()
        }
    }
    
    
    //MARK : color flicker
    func startFlickeringRedColor() {
        self.stopFlickerRedColor()
        self.flickerTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(Button.tickRedColor), userInfo: nil, repeats: true)
    }
    
    func stopFlickerRedColor() {
        if let _ = self.flickerTimer {
            self.flickerTimer!.invalidate()
            self.flickerTimer = nil
        }
        self.defaultColor()
    }
    
    func tickRedColor() {
        if (self.backgroundColor == UIColor.red) {
            self.defaultColor()
        } else { self.backgroundColor = UIColor.red }
    }
}
