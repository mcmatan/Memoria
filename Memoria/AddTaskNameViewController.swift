
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.enterNameTextField.text = currenctTaskCreator.getTaskName()
        self.title = self.currenctTaskCreator.getTaskBeaconIdentifier()!.major
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskName = Label()
        taskName.text = Content.getContent(ContentType.labelTxt, name: "taskName")
        enterNameTextField.placeholder = Content.getContent(ContentType.labelTxt, name: "enterTestName")
        enterNameTextField.textAlignment = NSTextAlignment.center
        enterNameTextField.layer.borderColor = UIColor.gray.cgColor
        enterNameTextField.layer.borderWidth = 0.5
        let done = Button()
        done.defaultStyle()
        done.setTitle(Content.getContent(ContentType.buttonTxt, name: "Done"), for: UIControlState())
        done.addTarget(self, action: #selector(AddTaskNameViewController.dontBtnPress), for: UIControlEvents.touchUpInside)
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
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[taskName]-[enterNameTextField]-[done]", options: [], metrics: nil, views: viewsDic)
        
        NSLayoutConstraint.activate(verticalLayout)
        taskName.topToViewControllerTopLayoutGuide(self)
        taskName.centerVerticlyInSuperView()
        enterNameTextField.centerVerticlyInSuperView()
        done.centerVerticlyInSuperView()
        
        print(taskName.intrinsicContentSize)

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
