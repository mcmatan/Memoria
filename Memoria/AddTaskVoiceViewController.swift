
import Foundation
import Swinject

class AddTaskVoiceViewController : ViewController {

    var container : Container
    let enterNameTextField = TextField()
    var recorder = Recorder()

    init(container : Container,taskName : String, tasksDates : Array<NSDate>) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let lblTopTxt = Label()
        lblTopTxt.numberOfLines = 0
        lblTopTxt.text = Content.getContent(ContentType.LabelTxt, name: "addTaskVoiceTopTxt")
        self.view.addSubview(lblTopTxt)
        lblTopTxt.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(self.view.snp_top).offset(UIConstants.defaultTopPadding)
            make.leading.equalTo(self.view.snp_leading).offset(UIConstants.defaultLeftPadding)
            make.trailing.equalTo(self.view.snp_trailing).offset(-UIConstants.defaultRightPadding)
        }

        let btnRecord = Button()
        btnRecord.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        btnRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnRecord"), forState: UIControlState.Normal)
        btnRecord.addTarget(self, action: "recordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnRecord)
        btnRecord.snp_makeConstraints {
            (make) -> Void in
            make.leading.equalTo(self.view.snp_leading).offset(UIConstants.defaultLeftPadding)
            make.centerY.equalTo(self.view.snp_centerY)
        }
        
        let btnStopRecord = Button()
        btnStopRecord.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnStopRecord.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnStopRecord"), forState: UIControlState.Normal)
        btnStopRecord.addTarget(self, action: "stopRecordButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnStopRecord)
        btnStopRecord.snp_makeConstraints {
            (make) -> Void in
            make.trailing.equalTo(self.view.snp_trailing).offset(-UIConstants.defaultRightPadding)
            make.centerY.equalTo(self.view.snp_centerY)
        }

        let btnPlay = Button()
        btnPlay.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        btnPlay.setTitle(Content.getContent(ContentType.ButtonTxt, name: "btnPlay"), forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: "playButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnPlay)
        btnPlay.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(btnStopRecord.snp_bottom).offset(UIConstants.paddingBetweenElements)
            make.centerX.equalTo(self.view.snp_centerX)
        }

        
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
}
