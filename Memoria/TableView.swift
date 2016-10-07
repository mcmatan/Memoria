
import Foundation
import UIKit

class TableView : UITableView {

    init() {
        super.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.backgroundColor = UIColor.white
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
