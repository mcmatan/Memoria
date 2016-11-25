//
//  TaskNotificationPopUp.swift
//  Memoria
//
//  Created by Matan Cohen on 3/8/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

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
        
        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task)
        
        let goodTimeOfDatString = notificationText.title
        self.lblGoodAfternoon.text = goodTimeOfDatString
        self.lblGoodAfternoon.font = UIFont.systemFont(ofSize: 26)
        self.lblGoodAfternoon.numberOfLines = 0
        self.lblGoodAfternoon.textAlignment = NSTextAlignment.center
        self.view .addSubview(self.lblGoodAfternoon)
        self.lblGoodAfternoon.topAlighnToViewBottom(imgLight, offset: 10)
        self.lblGoodAfternoon.centerHorizontlyInSuperView()
        
        self.lblItsTimeFor.text = notificationText.body
        self.lblItsTimeFor.defaultySubtitleGray()
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
        Events.shared.playSound.emit(self.task)
    }
    
    //MARK: Buttons
    
    func btnOkPress() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnPlayRecordPress() {
        self.playSound()
    }
}
