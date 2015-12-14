
import Foundation
import UIKit

class AddTaskViewController : ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingBetweenElements = 30
        let taskName = Label()
        taskName.text = Content.getContent(ContentType.LabelTxt, name: "taskName")
        let enterNameTextField = TextField()
        enterNameTextField.placeholder = Content.getContent(ContentType.LabelTxt, name: "enterTestName")
        let done = Button()
        done.setTitle(Content.getContent(ContentType.ButtonTxt, name: "Done"), forState: UIControlState.Normal)
        self.view.addSubview(taskName)
        self.view.addSubview(enterNameTextField)
        self.view.addSubview(done)
        taskName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_height).multipliedBy(0.2)
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
}
