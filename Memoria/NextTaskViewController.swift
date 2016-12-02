//
//  NextTaskViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 25/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class NextTaskViewController: ViewController {
    let tesksService: TasksServices
    let lblGoodTimeOfDay = Label()
    let lblTaskName = Label()
    let lblTimeToTask = Label()
    let imgTaskIcon = ImageView(image: UIImage(named:"placeholder"))
    var refreshIntervalListener: EventListener<Any>?
    
    //MARK: LifeCycle
    
    init(tesksService: TasksServices) {
        self.tesksService = tesksService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Content.getContent(ContentType.labelTxt, name: "NextTaskTitle")
        self.setupView()
        self.setupListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadViewWithData()
    }
    
    //MARK: Setup
    
    func setupView() {
        view.addSubview(lblGoodTimeOfDay)
        view.addSubview(lblTaskName)
        view.addSubview(self.imgTaskIcon)
        view.addSubview(lblTimeToTask)
        
        lblTimeToTask.defaultyTitle()
        
        self.imgTaskIcon.centerHorizontlyInSuperView()
        self.imgTaskIcon.centerVerticlyInSuperView(offset: -20)
        self.imgTaskIcon.setHeightAs(200)
        self.imgTaskIcon.setWidthAs(200)
        self.imgTaskIcon.contentMode = UIViewContentMode.scaleAspectFit
        
        lblTaskName.bottomAlighnToViewTop(self.imgTaskIcon, offset: -10)
        lblTaskName.centerHorizontlyInSuperView()
        
        lblGoodTimeOfDay.centerHorizontlyInSuperView()
        lblGoodTimeOfDay.bottomAlighnToViewTop(lblTaskName, offset: -5)
        
        lblTimeToTask.topAlighnToViewBottom(self.imgTaskIcon, offset: 10)
        lblTimeToTask.centerHorizontlyInSuperView()
        
    }
    
    func setupListener() {
        self.refreshIntervalListener = Events.shared.refreshInterval.on { event in
            self.loadViewWithData()
        }
    }
    
    //MARK: Load
    
    func loadViewWithData() {
        if let taskDisplay = self.tesksService.getUpcomingTaskDisplay() {
            self.showTaskInfo(taskDisplay: taskDisplay)
        } else {
            self.showNoTask()
        }
    }
    
    //MARK: Show
    
    func showNoTask() {
        self.lblGoodTimeOfDay.text = "No next task for today"
        self.lblTaskName.text = "Have a rest."
        self.lblTimeToTask.text = ""
        self.imgTaskIcon.image = UIImage(named: "relax")
        lblGoodTimeOfDay.defaultTitleGrayBold()
        lblTaskName.defaultySubtitleGray()
    }
    
    func showTaskInfo(taskDisplay: TaskDisplay) {
        let today = Date()
        lblGoodTimeOfDay.defaultyTitleLargeBold()
        lblTaskName.defaultyTitleLarge()
        self.lblGoodTimeOfDay.text = "Good \(today.dateToDayPartDeifinisionString() )"
        self.lblTaskName.text = taskDisplay.taskType
        self.lblTimeToTask.text = today.hoursIntillDateDescription(date: taskDisplay.date)
        self.imgTaskIcon.image = taskDisplay.image
        self.imgTaskIcon.defaultCornerRaduis()
    }
}
