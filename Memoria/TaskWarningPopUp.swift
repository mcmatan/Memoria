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

class TaskWarningPopUp : ViewController {
    let lblYouAllreadyTook = Label()
    let lblBeCareful = Label()
    let btnYes = Button()
    let btnSoundPlaying = Button()
    let task : Task
    let recorder = VoiceRecorder()

    init(task : Task) {
        self.task  = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCircle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.btnPlayRecordPress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imgError = ImageView(image: UIImage(named: "NotificationWarningImg"))
        self.view.addSubview(imgError)
        imgError.centerVerticlyInSuperView()
        imgError.widthLayoutAs(87)
        imgError.heightLayoutAs(117)
        imgError.topToViewControllerTopLayoutGuide(self, offset: 70)
        
        let didAllreadyString = "You Already \(self.task.taskName!) today"
        let laterTodayString = "The \(self.task.taskName!) is scheduled later today"
        let warningString = (self.task.taskTime <= NSDate()) ? didAllreadyString : laterTodayString
        
        self.lblYouAllreadyTook.text = warningString
        self.lblYouAllreadyTook.font = UIFont.systemFontOfSize(26)
        self.lblYouAllreadyTook.numberOfLines = 2
        self.lblYouAllreadyTook.textAlignment = NSTextAlignment.Center
        self.view .addSubview(self.lblYouAllreadyTook)
        self.lblYouAllreadyTook.topAlighnToViewBottom(imgError, offset: 23)
        self.lblYouAllreadyTook.centerVerticlyInSuperView()
        self.lblYouAllreadyTook.leadingToSuperView(true)
        self.lblYouAllreadyTook.trailingToSuperView(true)
        
        let didAllreadyStringBecareful = "Be careful not to do it twice"
        let laterTodayStringBecareful = "Please wait for \(task.taskTime!.toStringCurrentRegionShortTime())"
        let beCarefulString = (self.task.taskTime <= NSDate()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        self.lblBeCareful.text = beCarefulString
        self.lblBeCareful.titleGray()
        self.lblBeCareful.font = UIFont.systemFontOfSize(24)
        self.lblBeCareful.textAlignment = NSTextAlignment.Center
        self.lblBeCareful.numberOfLines = 0
        self.view.addSubview(self.lblBeCareful)
        self.lblBeCareful.centerVerticlyInSuperView()
        self.lblBeCareful.topAlighnToViewBottom(self.lblYouAllreadyTook, offset: 13)
        
        self.view.addSubview(self.btnYes)
        self.btnYes.notificiationThankYou()
        self.btnYes.centerVerticlyInSuperView()
        self.btnYes.topAlighnToViewBottom(self.lblBeCareful, offset: 40)
        self.btnYes.addTarget(self, action: "btnOkPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.btnSoundPlaying)
        self.btnSoundPlaying.notificiationPlayingGray()
        self.btnSoundPlaying.centerVerticlyInSuperView()
        self.btnSoundPlaying.bottomAlighnToViewBottom(self.view, offset: -40)
        self.btnSoundPlaying.addTarget(self, action: "btnPlayRecordPress", forControlEvents: UIControlEvents.TouchUpInside)
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
    func btnOkPress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func btnPlayRecordPress() {
        self.playSound()
    }

}