
import Foundation
import UIKit
import Swinject

class AddTaskNameViewController: ViewController {
    var container : Container
    let enterNameTextField = TextField()
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskTimeViewController : AddTaskTimeViewController?
    let beaconServices: IBeaconServices
    var beaconDraw = UIView()
    let btnDone = Button()
    
    init(container : Container, currenctTaskCreator : CurrenctTaskCreator,beaconServices: IBeaconServices) {
        self.container = container
        self.currenctTaskCreator = currenctTaskCreator
        self.beaconServices = beaconServices
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.enterNameTextField.text = currenctTaskCreator.getTaskName()
        self.title = self.currenctTaskCreator.getTaskBeaconIdentifier()!.major
        self.addBeaconShape()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskName = Label()
        taskName.text = Content.getContent(ContentType.labelTxt, name: "taskName")
        enterNameTextField.placeholder = Content.getContent(ContentType.labelTxt, name: "enterTestName")
        enterNameTextField.textAlignment = NSTextAlignment.center
        enterNameTextField.layer.borderColor = UIColor.gray.cgColor
        enterNameTextField.layer.borderWidth = 0.5
        btnDone.defaultStyle()
        btnDone.setTitle(Content.getContent(ContentType.buttonTxt, name: "Done"), for: UIControlState())
        btnDone.addTarget(self, action: #selector(AddTaskNameViewController.dontBtnPress), for: UIControlEvents.touchUpInside)
        self.view.addSubview(taskName)
        self.view.addSubview(enterNameTextField)
        self.view.addSubview(btnDone)

        taskName.translatesAutoresizingMaskIntoConstraints = false
        enterNameTextField.translatesAutoresizingMaskIntoConstraints = false
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [taskName, enterNameTextField, btnDone];
        UIViewAutoLayoutExtentions.equalHegihtForViews(views)
        UIViewAutoLayoutExtentions.equalWidthsForViews(views)
        
        let viewsDic : [String : AnyObject] =
        [
            "taskName" : taskName,
            "enterNameTextField" : enterNameTextField,
            "btnDone" : btnDone
        ]
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[taskName]-[enterNameTextField]-[btnDone]", options: [], metrics: nil, views: viewsDic)
        
        NSLayoutConstraint.activate(verticalLayout)
        taskName.topToViewControllerTopLayoutGuide(self)
        taskName.centerVerticlyInSuperView()
        enterNameTextField.centerVerticlyInSuperView()
        btnDone.centerVerticlyInSuperView()
        
        print(taskName.intrinsicContentSize)
    }
    
    func addBeaconShape() {
        self.beaconDraw.removeFromSuperview()
        let backgroundColor = self.beaconServices.getBeaconColorFor(beaconIdentifier: self.currenctTaskCreator.getTaskBeaconIdentifier()!)
        let beaconWidth = CGFloat(25)
        let beaconHeight = CGFloat(40)
        let rect = CGRect(x: self.view.centerX - beaconWidth/2, y: self.view.centerY - beaconHeight/2, width: beaconWidth, height: beaconHeight)
        let beaconShape = BeaconShape(rect: rect, backgroundColor: backgroundColor, lineColor: UIColor.white)
        self.beaconDraw = beaconShape
        
        let barButtonItem = UIBarButtonItem(customView: beaconShape)
        self.navigationItem.rightBarButtonItem = barButtonItem
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
