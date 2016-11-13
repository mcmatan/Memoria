//
//  TaskNotificationPopUp.swift
//  Memoria
//
//  Created by Matan Cohen on 3/8/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class TaskNotificationPopUp : ViewController {
    let lblGoodAfternoon = Label()
    let lblItsTimeFor = Label()
    let playSoundBtn = Button()
    let btnOk = Button()
    let task : Task
    
    init(task: Task, tasksServices: TasksServices) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let imgLight = ImageView(image: UIImage(named: "NotificationLight"))
        self.view.addSubview(imgLight)
        imgLight.centerHorizontlyInSuperView()
        imgLight.setWidthAs(120)
        imgLight.setHeightAs(150)
        imgLight.topToViewControllerTopLayoutGuide(self, offset: 70)
        
        let userName = Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpUserName")
        //format Good morning dor
        let goodTimeOfDatString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), task.taskTime!.dateToDayPartDeifinisionString(), userName)
        self.lblGoodAfternoon.text = goodTimeOfDatString
        self.lblGoodAfternoon.font = UIFont.systemFont(ofSize: 26)
        self.lblGoodAfternoon.numberOfLines = 0
        self.lblGoodAfternoon.textAlignment = NSTextAlignment.center
        self.view .addSubview(self.lblGoodAfternoon)
        self.lblGoodAfternoon.topAlighnToViewBottom(imgLight, offset: 10)
        self.lblGoodAfternoon.centerHorizontlyInSuperView()
        
        let currentDate = Date()
        
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeFor"), currentDate.toStringCurrentRegionShortTime(), task.taskType.name())
        // format"It's 4:00 PM.\nTime to feed your dog!"
        self.lblItsTimeFor.text = timeForString
        self.lblItsTimeFor.titleGray()
        self.lblItsTimeFor.font = UIFont.systemFont(ofSize: 23)
        self.lblItsTimeFor.textAlignment = NSTextAlignment.center
        self.lblItsTimeFor.numberOfLines = 0
        self.view.addSubview(self.lblItsTimeFor)
        self.lblItsTimeFor.centerHorizontlyInSuperView()
        self.lblItsTimeFor.topAlighnToViewBottom(self.lblGoodAfternoon, offset: 19)
        self.lblItsTimeFor.leadingToSuperView(true)
        self.lblItsTimeFor.trailingToSuperView(true)
        
        self.view.addSubview(self.playSoundBtn)
        self.playSoundBtn.notificiationPlaySoundBtn()
        self.playSoundBtn.centerHorizontlyInSuperView()
        self.playSoundBtn.topAlighnToViewBottom(self.lblItsTimeFor, offset: 39)
        self.playSoundBtn.addTarget(self, action: #selector(TaskNotificationPopUp.btnPlayRecordPress), for: UIControlEvents.touchUpInside)

        self.view.addSubview(self.btnOk)
        self.btnOk.notificiationOkThanksBtn()
        self.btnOk.centerHorizontlyInSuperView()
        self.btnOk.topAlighnToViewBottom(self.playSoundBtn, offset: 12)
        self.btnOk.addTarget(self, action: #selector(TaskNotificationPopUp.btnOkPress), for: UIControlEvents.touchUpInside)

    }
    
    //MARK: Actions
    
    func playSound() {
        NotificationCenter.default.post(name: NotificationsNames.kTask_Action_playSound, object: TaskActionDTO(task: self.task, localNotificationCategort: LocalNotificationCategotry.notification))
    }
    
    //MARK: Buttons
    
    func btnOkPress() {
        NotificationCenter.default.post(name: NotificationsNames.kTask_Action_Snooze, object: TaskActionDTO(task: self.task, localNotificationCategort: LocalNotificationCategotry.notification))
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnPlayRecordPress() {
        self.playSound()
    }
}
