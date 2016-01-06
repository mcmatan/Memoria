
import Foundation
import UIKit
import Swinject

class AddTaskTimeViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    var cellIdentifier = "cell"
    var tableView  = TableView()
    var datesList = Array<NSDate>()
    var container : Container
    private var taskName : String
    private var taskDates = Array<NSDate>()
    
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
        addTaskBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.view.addSubview(addTaskBtn)
        self.view.addSubview(self.tableView)
        addTaskBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(UIConstants.defaultTopPadding)
            make.leading.equalTo(self.view.snp_leading).offset(UIConstants.defaultLeftPadding)
        }
        addTaskBtn.addTarget(self, action: "addTimeButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        let doneBtn = Button()
        doneBtn.setTitle(Content.getContent(ContentType.LabelTxt, name: "addTimeDoneBtn"), forState: UIControlState.Normal)
        doneBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        doneBtn.addTarget(self, action: "doneBtnPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(doneBtn)
        doneBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(UIConstants.defaultTopPadding)
            make.trailing.equalTo(self.view.snp_trailing).offset(-UIConstants.defaultLeftPadding)
        }
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(addTaskBtn.snp_bottom).offset(UIConstants.defaultPaddingBetweenElemets)
            make.leading.equalTo(self.view.snp_leading).offset(UIConstants.defaultLeftPadding)
            make.trailing.equalTo(self.view.snp_trailing).offset(-(UIConstants.defaultLeftPadding))
            make.bottom.equalTo(self.view.snp_bottom).offset(-UIConstants.defaultLeftPadding)
        }
        self.tableView.layer.borderColor = UIColor.grayColor().CGColor
        self.tableView.layer.borderWidth = 1.0
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorColor = UIColor.grayColor()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        let addTaskVoiceViewController = self.container.resolve(AddTaskVoiceViewController.self, arguments: (self.taskName, self.taskDates))
        self.navigationController?.pushViewController(addTaskVoiceViewController!, animated: true)
    }
    
}
