
import Foundation
import UIKit

class TableView : UITableView {

    init() {
        super.init(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.backgroundColor = UIColor.whiteColor()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
