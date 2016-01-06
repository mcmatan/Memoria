
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
        
        let paddingBetweenElements = 40
        let taskName = Label()
        taskName.text = Content.getContent(ContentType.LabelTxt, name: "taskName")
        enterNameTextField.placeholder = Content.getContent(ContentType.LabelTxt, name: "enterTestName")
        enterNameTextField.textAlignment = NSTextAlignment.Center
        enterNameTextField.layer.borderColor = UIColor.grayColor().CGColor
        enterNameTextField.layer.borderWidth = 0.5
        let done = Button()
        done.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        done.setTitle(Content.getContent(ContentType.ButtonTxt, name: "Done"), forState: UIControlState.Normal)
        done.addTarget(self, action: "dontBtnPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(taskName)
        self.view.addSubview(enterNameTextField)
        self.view.addSubview(done)
        taskName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_topMargin).offset(100)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        enterNameTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(taskName.snp_bottom).offset(paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        done.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(enterNameTextField.snp_bottom).offset(paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        

    }
    
    //MARK: Button Presses
    
    func dontBtnPress() {
        if let inputTxt = self.enterNameTextField.text {
            let addTaskTimeViewController = self.container.resolve(AddTaskTimeViewController.self, argument: "\(inputTxt)")
            self.navigationController?.pushViewController(addTaskTimeViewController!, animated: true)
        }
    }
}
