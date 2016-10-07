
import Foundation
import Swinject

class AddTaskVoiceViewController : ViewController {

    var container : Container
    let enterNameTextField = TextField()
    var recorder = VoiceRecorder()
    var currenctTaskCreator : CurrenctTaskCreator
    let btnRecord = Button()
    var addTaskTimePriorityViewController : AddTaskTimePriorityController?

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
        if let isVoiceRecorder = currenctTaskCreator.getTaskVoiceURL() {
            self.recorder.setURLToPlayFrom(isVoiceRecorder)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Content.getContent(ContentType.labelTxt, name: "addTaskVoiceTitle")

        btnRecord.defaultStyle()
        btnRecord.setTitle(Content.getContent(ContentType.buttonTxt, name: "btnRecord"), for: UIControlState.normal)
        btnRecord.addTarget(self, action: #selector(AddTaskVoiceViewController.recordButtonPress), for: UIControlEvents.touchUpInside)
        
        let btnStopRecord = Button()
        btnStopRecord.setTitle(Content.getContent(ContentType.buttonTxt, name: "btnStopRecord"), for: UIControlState.normal)
        btnStopRecord.addTarget(self, action: #selector(AddTaskVoiceViewController.stopRecordButtonPress), for: UIControlEvents.touchUpInside)
        btnStopRecord.defaultStyle()

        let btnPlay = Button()
        btnPlay.defaultStyle()
        btnPlay.setTitle(Content.getContent(ContentType.buttonTxt, name: "btnPlay"), for: UIControlState.normal)
        btnPlay.addTarget(self, action: #selector(AddTaskVoiceViewController.playButtonPress), for: UIControlEvents.touchUpInside)
        
        let btnDone = Button()
        btnDone.defaultStyle()
        btnDone.setTitle(Content.getContent(ContentType.buttonTxt, name: "DoneButton"), for: UIControlState.normal)
        btnDone.addTarget(self, action: #selector(AddTaskVoiceViewController.btnDonePress), for: UIControlEvents.touchUpInside)

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
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[btnRecord]-[btnStopRecord]-[btnPlay]-[btnDone]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsKeys)
        
        btnRecord.topToViewControllerTopLayoutGuide(self, offset: 10)
        btnRecord.centerVerticlyInSuperView()
        NSLayoutConstraint.activate(verticalLayout)
        
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
        
        if let _ = self.addTaskTimePriorityViewController {} else {
            self.addTaskTimePriorityViewController = self.container.resolve(AddTaskTimePriorityController.self)
        }
        
        self.navigationController?.pushViewController(self.addTaskTimePriorityViewController!, animated: true)
        
    }
    
    
}
