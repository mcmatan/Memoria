//
//  TaskWarningPopUp.swift
//  Memoria
//
//  Created by Matan Cohen on 3/10/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class TaskWarningPopUp : ViewController {
    let lblYouAllreadyTook = Label()
    let lblBeCareful = Label()
    let btnYes = Button()
    let btnSoundPlaying = Button()
    let task : Task

    init(task : Task) {
        self.task  = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let imgError = ImageView(image: UIImage(named: "NotificationWarningImg"))
        self.view.addSubview(imgError)
        imgError.centerVerticlyInSuperView()
        imgError.widthLayoutAs(87)
        imgError.heightLayoutAs(117)
        imgError.topToViewControllerTopLayoutGuide(self, offset: 70)
        
        
        let didAllreadyString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidAllready"), self.task.taskType.name())
        let laterTodayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidLaterToday"), self.task.taskType.name())
        let warningString = (self.task.taskTime <= Date()) ? didAllreadyString : laterTodayString
        
        self.lblYouAllreadyTook.text = warningString
        self.lblYouAllreadyTook.font = UIFont.systemFont(ofSize: 26)
        self.lblYouAllreadyTook.numberOfLines = 2
        self.lblYouAllreadyTook.textAlignment = NSTextAlignment.center
        self.view .addSubview(self.lblYouAllreadyTook)
        self.lblYouAllreadyTook.topAlighnToViewBottom(imgError, offset: 23)
        self.lblYouAllreadyTook.centerVerticlyInSuperView()
        self.lblYouAllreadyTook.leadingToSuperView(true)
        self.lblYouAllreadyTook.trailingToSuperView(true)
        
        let didAllreadyStringBecareful = Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidCerfulNotToTakeTwice")
        let laterTodayStringBecareful = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidPleaseWaitFor"), task.taskTime!.toStringCurrentRegionShortTime())
        let beCarefulString = (self.task.taskTime <= Date()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        self.lblBeCareful.text = beCarefulString
        self.lblBeCareful.titleGray()
        self.lblBeCareful.font = UIFont.systemFont(ofSize: 24)
        self.lblBeCareful.textAlignment = NSTextAlignment.center
        self.lblBeCareful.numberOfLines = 0
        self.view.addSubview(self.lblBeCareful)
        self.lblBeCareful.centerVerticlyInSuperView()
        self.lblBeCareful.topAlighnToViewBottom(self.lblYouAllreadyTook, offset: 13)
        
        self.view.addSubview(self.btnYes)
        self.btnYes.notificiationThankYou()
        self.btnYes.centerVerticlyInSuperView()
        self.btnYes.topAlighnToViewBottom(self.lblBeCareful, offset: 40)
        self.btnYes.addTarget(self, action: #selector(TaskWarningPopUp.btnOkPress), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self.btnSoundPlaying)
        self.btnSoundPlaying.notificiationPlayingGray()
        self.btnSoundPlaying.centerVerticlyInSuperView()
        self.btnSoundPlaying.bottomAlighnToViewBottom(self.view, offset: -40)
        self.btnSoundPlaying.addTarget(self, action: #selector(TaskWarningPopUp.btnPlayRecordPress), for: UIControlEvents.touchUpInside)
    }
    
    //MARK: Actions
    
    func playSound() {
        NotificationCenter.default.post(name: NotificationsNames.kTask_Action_playSound, object: TaskActionDTO(task: self.task, localNotificationCategort: LocalNotificationCategotry.warning))
    }
    
    //MARK: Buttons
    func btnOkPress() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnPlayRecordPress() {
        self.playSound()
    }

}
