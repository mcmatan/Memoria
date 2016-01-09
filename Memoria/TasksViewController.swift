

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
        
        topExpelenationText.translatesAutoresizingMaskIntoConstraints = false
        thisIsMyLocation.translatesAutoresizingMaskIntoConstraints = false
        or.translatesAutoresizingMaskIntoConstraints = false
        manageTasks.translatesAutoresizingMaskIntoConstraints = false
        
        let topLayoutGuide = self.topLayoutGuide
        let bottomLayoutGuide = self.bottomLayoutGuide
        
        let views : [String : AnyObject] =
        ["topExpelenationText" : topExpelenationText,
            "thisIsMyLocation" : thisIsMyLocation,
            "or" : or,
            "manageTasks" : manageTasks,
            "topLayoutGuide" : topLayoutGuide,
            "bottomLayoutGuide" : bottomLayoutGuide
        ]
        
        var allConstrains = [NSLayoutConstraint]()
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topLayoutGuide]-[topExpelenationText]-[thisIsMyLocation]-[or(topExpelenationText)]-[manageTasks]-[bottomLayoutGuide]"
            , options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        
        let horizintalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[topExpelenationText]|"
            , options: [], metrics: nil, views: views)
        
        allConstrains += verticalLayout
        allConstrains += horizintalLayout
        NSLayoutConstraint.activateConstraints(allConstrains)

    }
    
    //MARK: Buttons presses
    
    func thisIsMyLocationPress() {
        let addTask = self.container.resolve(AddTaskNameViewController.self)
        self.navigationController?.pushViewController(addTask!, animated: true)
    }
}
