//
//  TaskVerificationPopUp.swift
//  Memoria
//
//  Created by Matan Cohen on 3/9/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class TaskVerificationPopUp : ViewController {
    let lblISeeYourNear = Label()
    let lblDidYouYet = Label()
    let btnYes = Button()
    let btnRemindMeLayer = Button()
    let btnSoundPlaying = Button()
    let task : Task
    let recorder = VoiceRecorder()
    let tasksServices : TasksServices
    
    init(task : Task, tasksServices : TasksServices) {
        self.task = task
        self.tasksServices = tasksServices
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCircle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.playSound()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imgLight = ImageView(image: UIImage(named: "NotificationLight"))
        self.view.addSubview(imgLight)
        imgLight.centerVerticlyInSuperView()
        imgLight.widthLayoutAs(120)
        imgLight.heightLayoutAs(150)
        imgLight.topToViewControllerTopLayoutGuide(self, offset: 70)
        
        self.lblISeeYourNear.text = String.localizedStringWithFormat(Content.getContent(ContentType.LabelTxt, name: "TaskVerificationPopUpISeeYourNeer"), self.task.taskName!)
        self.lblISeeYourNear.font = UIFont.systemFontOfSize(28)
        self.lblISeeYourNear.numberOfLines = 0
        self.lblISeeYourNear.textAlignment = NSTextAlignment.Center
        self.view .addSubview(self.lblISeeYourNear)
        self.lblISeeYourNear.topAlighnToViewBottom(imgLight, offset: 10)
        self.lblISeeYourNear.centerVerticlyInSuperView()
        self.lblISeeYourNear.leadingToSuperView(true)
        self.lblISeeYourNear.trailingToSuperView(true)
        
        
        self.lblDidYouYet.text = String.localizedStringWithFormat(Content.getContent(ContentType.LabelTxt, name: "TaskVerificationPopUpDidYouYet"), self.task.taskName!)
        self.lblDidYouYet.titleGray()
        self.lblDidYouYet.font = UIFont.systemFontOfSize(22)
        self.lblDidYouYet.textAlignment = NSTextAlignment.Center
        self.lblDidYouYet.numberOfLines = 0
        self.view.addSubview(self.lblDidYouYet)
        self.lblDidYouYet.centerVerticlyInSuperView()
        self.lblDidYouYet.topAlighnToViewBottom(self.lblISeeYourNear, offset: 13)
        self.lblDidYouYet.leadingToSuperView(true)
        self.lblDidYouYet.trailingToSuperView(true)
        
        self.view.addSubview(self.btnYes)
        self.btnYes.notificiationYesVericiation()
        self.btnYes.centerVerticlyInSuperView()
        self.btnYes.topAlighnToViewBottom(self.lblDidYouYet, offset: 53)
        self.btnYes.addTarget(self, action: #selector(TaskVerificationPopUp.btnYesPress), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(self.btnRemindMeLayer)
        self.btnRemindMeLayer.notificiationRemindMeLater()
        self.btnRemindMeLayer.centerVerticlyInSuperView()
        self.btnRemindMeLayer.topAlighnToViewBottom(self.btnYes, offset: 13)
        self.btnRemindMeLayer.addTarget(self, action: #selector(TaskVerificationPopUp.btnRemoingMeLaterPress), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(self.btnSoundPlaying)
        self.btnSoundPlaying.notificiationPlayingGray()
        self.btnSoundPlaying.centerVerticlyInSuperView()
        self.btnSoundPlaying.bottomAlighnToViewBottom(self.view, offset: -40)
        self.btnSoundPlaying.addTarget(self, action: #selector(TaskVerificationPopUp.btnPlayRecordPress), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //MARK: Actions
    
    func playSound() {
        if let isSound = self.task.taskVoiceURL {
            if ("" != isSound.absoluteString) {
                self.recorder.soundFileURL = isSound
                self.recorder.play()
            }
        }
    }
    
    //MARK: Buttons
    
    func btnYesPress() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.tasksServices.setTaskAsDone(self.task)
        }

    }
    
    func btnRemoingMeLaterPress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func btnPlayRecordPress() {
        self.playSound()
    }

}