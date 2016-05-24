
import Foundation
import UIKit
import Swinject

class AddTaskTimeViewController : ViewController {
    var cellIdentifier = "cell"
    var lblTime  = Label()
    var container : Container
    var chosenTime = NSDate()
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskVoiceViewController : AddTaskVoiceViewController?
    
    init(container : Container, currenctTaskCreator : CurrenctTaskCreator) {
        self.container = container
        self.currenctTaskCreator = currenctTaskCreator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.currenctTaskCreator.getTaskName()
        if let isTimes = currenctTaskCreator.getTaskTime() {
            self.chosenTime = isTimes
            self.setTimeToDisplay(isTimes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addTaskBtn = Button()
        addTaskBtn.setTitle(Content.getContent(ContentType.LabelTxt, name: "addTaskTimeButton"), forState: UIControlState.Normal)
        addTaskBtn.defaultStyle()
        addTaskBtn.addTarget(self, action: #selector(AddTaskTimeViewController.addTimeButtonPress), forControlEvents: UIControlEvents.TouchUpInside)
        let doneBtn = Button()
        doneBtn.setTitle(Content.getContent(ContentType.LabelTxt, name: "addTimeDoneBtn"), forState: UIControlState.Normal)
        doneBtn.addTarget(self, action: #selector(AddTaskTimeViewController.doneBtnPress), forControlEvents: UIControlEvents.TouchUpInside)
        doneBtn.defaultStyle()
    
        self.lblTime.font = UIFont.systemFontOfSize(25)
        self.lblTime.textAlignment = NSTextAlignment.Center
        self.lblTime.numberOfLines = 0
        
        self.view.addSubview(addTaskBtn)
        self.view.addSubview(self.lblTime)
        self.view.addSubview(doneBtn)

        
        addTaskBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        self.lblTime.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [doneBtn, addTaskBtn,lblTime]
        let viewsInfoDic : [String : AnyObject] =
        [
            "addTaskBtn" : addTaskBtn,
            "doneBtn" : doneBtn,
            "lblTime" : self.lblTime
        ]
        

        UIViewAutoLayoutExtentions.equalWidthsForViews(views)
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[addTaskBtn]-[doneBtn]-[lblTime]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activateConstraints(verticalLayout)
        
        addTaskBtn.topToViewControllerTopLayoutGuide(self, offset: 20)
        addTaskBtn.centerVerticlyInSuperView()
    }
    
    
    func addTimeButtonPress() {
        let txt = Content.getContent(ContentType.LabelTxt, name: "AddTaskTimeDatePickerDialog")
        DatePickerDialog().show(txt, datePickerMode: UIDatePickerMode.DateAndTime) { (date) -> Void in
            print(date)
            self.chosenTime = date
            self.setTimeToDisplay(date)
        }
    }
    
    func setTimeToDisplay(date : NSDate) {
        let timeString = date.descriptionWithLocale(NSLocale.currentLocale())
        self.lblTime.text = "\(timeString)"
    }

    func doneBtnPress() {
        
        self.currenctTaskCreator.setTaskTime(self.chosenTime)
    
        if let _ = self.addTaskVoiceViewController {} else {
            self.addTaskVoiceViewController =  self.container.resolve(AddTaskVoiceViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskVoiceViewController!, animated: true)
        
    }

}
