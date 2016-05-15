
import Foundation
import UIKit
import Swinject

class AddTaskNameViewController: ViewController {
    var container : Container
    let enterNameTextField = TextField()
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskTimeViewController : AddTaskTimeViewController?
    
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
        
        self.enterNameTextField.text = currenctTaskCreator.getTaskName()
        self.title = self.currenctTaskCreator.getTaskBeaconIdentifier()!.major
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskName = Label()
        taskName.text = Content.getContent(ContentType.LabelTxt, name: "taskName")
        enterNameTextField.placeholder = Content.getContent(ContentType.LabelTxt, name: "enterTestName")
        enterNameTextField.textAlignment = NSTextAlignment.Center
        enterNameTextField.layer.borderColor = UIColor.grayColor().CGColor
        enterNameTextField.layer.borderWidth = 0.5
        let done = Button()
        done.defaultStyle()
        done.setTitle(Content.getContent(ContentType.ButtonTxt, name: "Done"), forState: UIControlState.Normal)
        done.addTarget(self, action: #selector(AddTaskNameViewController.dontBtnPress), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(taskName)
        self.view.addSubview(enterNameTextField)
        self.view.addSubview(done)

        taskName.translatesAutoresizingMaskIntoConstraints = false
        enterNameTextField.translatesAutoresizingMaskIntoConstraints = false
        done.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [taskName, enterNameTextField, done];
        UIViewAutoLayoutExtentions.equalHegihtForViews(views)
        UIViewAutoLayoutExtentions.equalWidthsForViews(views)
        
        let viewsDic : [String : AnyObject] =
        [
            "taskName" : taskName,
            "enterNameTextField" : enterNameTextField,
            "done" : done
        ]
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[taskName]-[enterNameTextField]-[done]", options: [], metrics: nil, views: viewsDic)
        
        NSLayoutConstraint.activateConstraints(verticalLayout)
        taskName.topToViewControllerTopLayoutGuide(self)
        taskName.centerVerticlyInSuperView()
        enterNameTextField.centerVerticlyInSuperView()
        done.centerVerticlyInSuperView()
        
        print(taskName.intrinsicContentSize())

    }
    
    //MARK: Button Presses
    
    func dontBtnPress() {
        if let inputTxt = self.enterNameTextField.text {
                let text = "\(inputTxt)"
                self.currenctTaskCreator.setTaskName(text)
            
            if let _ = self.addTaskTimeViewController {} else {
                self.addTaskTimeViewController = self.container.resolve(AddTaskTimeViewController.self)
            }
                self.navigationController?.pushViewController(self.addTaskTimeViewController!, animated: true)
            }
    }
}
