//
//  NextTaskViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 25/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class NextTaskViewController: ViewController {
    let tesksService: TasksServices
    var refeshTimer: Timer?
    let refresTimeInterval: TimeInterval = 60.0
    let lblGoodTimeOfDay = Label()
    let lblTaskName = Label()
    let lblTimeToTask = Label()
    let imgTaskIcon = ImageView(image: UIImage(named:"placeholder"))
    
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
        self.setupTimer()
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
        
        lblGoodTimeOfDay.defaultyLargeTitle()
        lblTaskName.defaultyTitle()
        
        lblTimeToTask.defaultyTitle()
        
        lblGoodTimeOfDay.centerHorizontlyInSuperView()
        lblGoodTimeOfDay.topToSuperView(true)
        
        lblTaskName.topAlighnToViewBottom(lblGoodTimeOfDay)
        lblTaskName.centerHorizontlyInSuperView()
        
        self.imgTaskIcon.topAlighnToViewBottom(lblTaskName, offset: 20)
        self.imgTaskIcon.centerHorizontlyInSuperView()
        self.imgTaskIcon.setHeightAs(200)
        self.imgTaskIcon.setWidthAs(200)
        self.imgTaskIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.imgTaskIcon.clipsToBounds = true
        
        
        lblTimeToTask.topAlighnToViewBottom(self.imgTaskIcon, offset: 20)
        lblTimeToTask.centerHorizontlyInSuperView()
    }
    
    func setupTimer() {
        self.refeshTimer = Timer.scheduledTimer(withTimeInterval: refresTimeInterval, repeats: true, block: { timer in
            self.loadViewWithData()
        })
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
        self.lblGoodTimeOfDay.text = "There is no next task for today"
        self.lblTaskName.text = "Have a rest (:"
        self.lblTimeToTask.text = ""
        self.imgTaskIcon.image = UIImage(named: "smilyNoTasks")
    }
    
    func showTaskInfo(taskDisplay: TaskDisplay) {
        self.lblGoodTimeOfDay.text = "Good evening"//TBD Inset currect time text THERE IS IN THE DATE EXTENTINOS
        self.lblTaskName.text = taskDisplay.taskType
        self.lblTimeToTask.text = "In 1 houre" //TBD
        self.imgTaskIcon.image = taskDisplay.image
    }
}
