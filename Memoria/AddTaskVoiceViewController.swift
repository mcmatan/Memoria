
import Foundation
import Swinject

class AddTaskVoiceViewController : ViewController {

    var container : Container
    let enterNameTextField = TextField()
    var recorder = Recorder()
    let taskName : String
    let tasksDates : Array<NSDate>

    init(container : Container,taskName : String, tasksDates : Array<NSDate>) {
        self.container = container
        self.taskName = taskName
        self.tasksDates = tasksDates
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Content.getContent(ContentType.LabelTxt, name: "addTaskVoiceTitle")

        let btnRecord = Button()
        btnRecord.defaultStyle()
        btnRecord.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        btnRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnRecord"), forState: UIControlState.Normal)
        btnRecord.addTarget(self, action: "recordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnStopRecord = Button()
        btnStopRecord.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnStopRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnStopRecord"), forState: UIControlState.Normal)
        btnStopRecord.addTarget(self, action: "stopRecordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnStopRecord.defaultStyle()

        let btnPlay = Button()
        btnPlay.defaultStyle()
        btnPlay.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        btnPlay.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnPlay"), forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: "playButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnDone = Button()
        btnDone.defaultStyle()
        btnDone.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnDone.setTitle(Content.getContent(ContentType.ButtonTxt, name: "DoneButton"), forState: UIControlState.Normal)
        btnDone.addTarget(self, action: "btnDonePress", forControlEvents: UIControlEvents.TouchUpInside)

        btnRecord.translatesAutoresizingMaskIntoConstraints = false
        btnStopRecord.translatesAutoresizingMaskIntoConstraints = false
        btnPlay.translatesAutoresizingMaskIntoConstraints = false
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(btnRecord)
        self.view.addSubview(btnStopRecord)
        self.view.addSubview(btnPlay)
        self.view.addSubview(btnDone)
        
        
        let viewsKeys : [String : AnyObject] =
        [
            "btnRecord" : btnRecord,
            "btnStopRecord" : btnStopRecord,
            "btnPlay" : btnPlay,
            "btnDone" : btnDone
        ]
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[btnRecord]-[btnStopRecord]-[btnPlay]-[btnDone]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsKeys)
        
        btnRecord.topToViewControllerTopLayoutGuide(self)
        btnRecord.centerVerticlyInSuperView()
        
        NSLayoutConstraint.activateConstraints(verticalLayout)
        
    }

    //MARK: Buttons presses

    func recordButtonPress() {
        self.recorder.record()
    }

    func stopRecordButtonPress() {
        self.recorder.stop()
    }

    func playButtonPress() {
        self.recorder.play()
    }
    
    func btnDonePress() {
        let addTaskConfirmationPage = self.container.resolve(AddTaskConfirmationViewController.self,
            arguments: (self.taskName, self.tasksDates, self.recorder.getRecordingURL()))
        
        
        if let _ = self.navigationController {
                self.navigationController?.pushViewController(addTaskConfirmationPage!, animated: true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
}
