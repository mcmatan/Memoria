
import Foundation
import UIKit
import Swinject

class AddTaskTimeViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    var cellIdentifier = "cell"
    var tableView  = TableView()
    var datesList = Array<NSDate>()
    var container : Container
    private var taskName : String
    
    init(taskName : String, container : Container) {
        self.taskName = taskName
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.taskName
        
        let addTaskBtn = Button()
        addTaskBtn.setTitle(Content.getContent(ContentType.LabelTxt, name: "addTaskTimeButton"), forState: UIControlState.Normal)
        addTaskBtn.defaultStyle()
        addTaskBtn.addTarget(self, action: "addTimeButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        let doneBtn = Button()
        doneBtn.setTitle(Content.getContent(ContentType.LabelTxt, name: "addTimeDoneBtn"), forState: UIControlState.Normal)
        doneBtn.addTarget(self, action: "doneBtnPress", forControlEvents: UIControlEvents.TouchUpInside)
        doneBtn.defaultStyle()
    
        self.tableView.layer.borderColor = UIColor.grayColor().CGColor
        self.tableView.layer.borderWidth = 1.0
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorColor = UIColor.grayColor()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(addTaskBtn)
        self.view.addSubview(self.tableView)
        self.view.addSubview(doneBtn)

        
        addTaskBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [doneBtn, addTaskBtn,tableView]
        let viewsInfoDic : [String : AnyObject] =
        [
            "addTaskBtn" : addTaskBtn,
            "doneBtn" : doneBtn,
            "tableView" : self.tableView
        ]
        

        UIViewAutoLayoutExtentions.equalWidthsForViews(views)
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[addTaskBtn]-[doneBtn]-[tableView]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activateConstraints(verticalLayout)
        
        addTaskBtn.topToViewControllerTopLayoutGuide(self)
        tableView.bottomToViewControllerTopLayoutGuide(self)
        addTaskBtn.centerVerticlyInSuperView()
    }
    
    //MARK: TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currenctTime = self.datesList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if let timeString = currenctTime.toString() {
            cell?.textLabel?.text = "\(timeString)"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datesList.count
    }
    
    func addTimeButtonPress() {
        DatePickerDialog().show("Choose a date", datePickerMode: UIDatePickerMode.DateAndTime) { (date) -> Void in
            self.datesList.append(date)
            print(date)
            self.tableView.reloadData()
        }
    }

    func doneBtnPress() {
        
        if let _ = self.navigationController {
            let addTaskVoiceViewController = self.container.resolve(AddTaskVoiceViewController.self, arguments: (self.taskName, self.datesList))
            self.navigationController?.pushViewController(addTaskVoiceViewController!, animated: true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
    }
    
}
