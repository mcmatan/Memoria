

import Foundation
import UIKit
import Swinject

class TasksViewController : ViewController {
    let container : Container
    
    init(container : Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topExpelenationText = Label()
        topExpelenationText.numberOfLines = 0
        topExpelenationText.textAlignment = NSTextAlignment.Center
        let txt = Content.getContent(ContentType.LabelTxt, name: "TesksFirstExplenation")
        topExpelenationText.text = txt
        let thisIsMyLocation = Button()
        thisIsMyLocation.defaultStyle()
        thisIsMyLocation.setTitle(Content.getContent(ContentType.ButtonTxt, name: "ThisIsMyLocationTask"), forState: UIControlState.Normal)
        thisIsMyLocation.addTarget(self, action: "thisIsMyLocationPress", forControlEvents: UIControlEvents.TouchUpInside)
        let or = Label()
        or.text = Content.getContent(ContentType.LabelTxt, name: "or")
        let manageTasks = Button()
        manageTasks.defaultStyle()
        manageTasks.setTitle(Content.getContent(ContentType.ButtonTxt, name: "ManageTasks"), forState: UIControlState.Normal)
        self.view.addSubview(topExpelenationText)
        self.view.addSubview(thisIsMyLocation)
        self.view.addSubview(or)
        self.view.addSubview(manageTasks)
        topExpelenationText.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(100)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        thisIsMyLocation.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topExpelenationText.snp_bottom).offset(UIConstants.paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        or.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(thisIsMyLocation.snp_bottom).offset(UIConstants.paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        manageTasks.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(or.snp_bottom).offset(UIConstants.paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }
    }
    
    //MARK: Buttons presses
    
    func thisIsMyLocationPress() {
        let addTask = self.container.resolve(AddTaskNameViewController.self)
        self.navigationController?.pushViewController(addTask!, animated: true)
    }
}
