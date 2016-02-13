
import Foundation
import Swinject

class AddTaskVoiceViewController : ViewController {

    var container : Container
    let enterNameTextField = TextField()
    var recorder = VoiceRecorder()
    var currenctTaskCreator : CurrenctTaskCreator
    let btnRecord = Button()
    var addTaskConfirmationViewController : AddTaskConfirmationViewController?

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
        if let isVoiceRecorder = currenctTaskCreator.getTaskVoiceURL() {
            self.recorder.setURLToPlayFrom(isVoiceRecorder)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Content.getContent(ContentType.LabelTxt, name: "addTaskVoiceTitle")

        btnRecord.defaultStyle()
        btnRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnRecord"), forState: UIControlState.Normal)
        btnRecord.addTarget(self, action: "recordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnStopRecord = Button()
        btnStopRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnStopRecord"), forState: UIControlState.Normal)
        btnStopRecord.addTarget(self, action: "stopRecordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnStopRecord.defaultStyle()

        let btnPlay = Button()
        btnPlay.defaultStyle()
        btnPlay.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnPlay"), forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: "playButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnDone = Button()
        btnDone.defaultStyle()
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
        self.btnRecord.startFlickeringRedColor()
        self.recorder.record()
    }

    func stopRecordButtonPress() {
        self.btnRecord.stopFlickerRedColor()
        self.recorder.stop()
    }

    func playButtonPress() {
        self.btnRecord.stopFlickerRedColor()        
        self.recorder.play()
    }
    
    func btnDonePress() {
        self.stopRecordButtonPress()
        self.currenctTaskCreator.setTaskVoiceURL(self.recorder.getRecordingURL())
        
        if let _ = self.addTaskConfirmationViewController {} else {
            self.addTaskConfirmationViewController = self.container.resolve(AddTaskConfirmationViewController.self)
        }
        
        self.navigationController?.pushViewController(self.addTaskConfirmationViewController!, animated: true)
        
    }
    
    
}
