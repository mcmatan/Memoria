//
//  setTaskTypeBtnViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 06/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class AddTaskTypeViewController : ViewController {
    
    var cellIdentifier = "cell"
    var lblTaskType  = Label()
    var container : Container
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskTimeViewController: AddTaskTimeViewController?
    var pickerWithBlock: UIPickerWithBlock?
    
    init(container : Container, currenctTaskCreator : CurrenctTaskCreator) {
        self.container = container
        self.currenctTaskCreator = currenctTaskCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.currenctTaskCreator.task.taskType.name()
        self.lblTaskType.text = self.currenctTaskCreator.task.taskType.name()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTaskType.alpha = 0
        let setTaskTypeBtn = Button()
        setTaskTypeBtn.setTitle(Content.getContent(ContentType.labelTxt, name: "chooseTaskTypeBtn"), for: UIControlState())
        setTaskTypeBtn.defaultStyle()
        setTaskTypeBtn.addTarget(self, action: #selector(AddTaskTypeViewController.btnChooseTaskTypePress), for: UIControlEvents.touchUpInside)
        let doneBtn = Button()
        doneBtn.setTitle(Content.getContent(ContentType.labelTxt, name: "addTimeDoneBtn"), for: UIControlState())
        doneBtn.addTarget(self, action: #selector(AddTaskTimeViewController.doneBtnPress), for: UIControlEvents.touchUpInside)
        doneBtn.defaultStyle()
        
        self.lblTaskType.font = UIFont.systemFont(ofSize: 25)
        self.lblTaskType.textAlignment = NSTextAlignment.center
        self.lblTaskType.numberOfLines = 0
        
        self.view.addSubview(setTaskTypeBtn)
        self.view.addSubview(self.lblTaskType)
        self.view.addSubview(doneBtn)
        
        
        setTaskTypeBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        self.lblTaskType.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [doneBtn, setTaskTypeBtn,lblTaskType] as [Any]
        let viewsInfoDic : [String : AnyObject] =
            [
                "setTaskTypeBtn" : setTaskTypeBtn,
                "doneBtn" : doneBtn,
                "lblTaskType" : self.lblTaskType
        ]
        
        
        UIViewAutoLayoutExtentions.equalWidthsForViews(views as! [UIView])
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[setTaskTypeBtn]-[doneBtn]-[lblTaskType]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activate(verticalLayout)
        
        setTaskTypeBtn.topToViewControllerTopLayoutGuide(self, offset: 20)
        setTaskTypeBtn.centerVerticlyInSuperView()
    }
    
    func btnChooseTaskTypePress() {
        let titles = [TaskType.drugs.name(), TaskType.brushTeeth.name(), TaskType.food.name()]
        self.pickerWithBlock = UIPickerWithBlock(viewController: self, titles: titles) { index, title  in
            var choosenTaskType: TaskType
            switch title {
            case TaskType.brushTeeth.name():
                choosenTaskType = TaskType.brushTeeth
            case TaskType.drugs.name():
                choosenTaskType = TaskType.drugs
            case TaskType.food.name():
                choosenTaskType = TaskType.food
            default:
                print("No Task title has match")
                choosenTaskType = TaskType.food
            }
            
            self.lblTaskType.alpha = 1
            self.lblTaskType.text = title
            
            self.currenctTaskCreator.setTaskType(type: choosenTaskType)
        }
    }
    
    
    func doneBtnPress() {
        if let _ = self.addTaskTimeViewController {} else {
            self.addTaskTimeViewController =  self.container.resolve(AddTaskTimeViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskTimeViewController!, animated: true)
    }
    
}
