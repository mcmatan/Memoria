
import Foundation
import UIKit
import ReactiveCocoa
import Swinject

class AddTaskNameViewController: ViewController {
    var container : Container
    let enterNameTextField = TextField()
    
    init(container : Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        done.addTarget(self, action: "dontBtnPress", forControlEvents: UIControlEvents.TouchUpInside)
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
            "V:[taskName]-[enterNameTextField]-[done]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsDic)
        
        NSLayoutConstraint.activateConstraints(verticalLayout)
        taskName.topToViewControllerTopLayoutGuide(self)
        taskName.centerVerticlyInSuperView()
        
        print(taskName.intrinsicContentSize())

    }
    
    //MARK: Button Presses
    
    func dontBtnPress() {
        if let inputTxt = self.enterNameTextField.text {
            if let _ = self.navigationController {
                let addTaskTimeViewController = self.container.resolve(AddTaskTimeViewController.self, argument: "\(inputTxt)")
                self.navigationController?.pushViewController(addTaskTimeViewController!, animated: true)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
