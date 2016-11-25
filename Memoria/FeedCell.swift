//
//  FeedCell.swift
//  Memoria
//
//  Created by Matan Cohen on 25/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class FeedCell: Cell {
    let imgTask = ImageView(image: UIImage(named: "placeholder"))
    let lblTitle = Label()
    let lblSubtitle = Label()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    func setupView() {
        self.contentView.addSubview(imgTask)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblSubtitle)
        
        imgTask.leadingToSuperView(false)
        imgTask.topToSuperView(false)
        imgTask.bottomToSuperView(false)
        imgTask.widthAsViewHeight(viewHeight: self.contentView)
        imgTask.contentMode = UIViewContentMode.scaleAspectFit
        imgTask.clipsToBounds = true
        
        lblTitle.topToSuperView(true)
        lblTitle.defaultyTitle()
        lblTitle.leadingToViewTrailing(view: imgTask, offset: 20)
        
        lblSubtitle.defaultySubtitle()
        lblSubtitle.topAlighnToViewBottom(lblTitle)
        lblSubtitle.leadingToViewLeading(view: lblTitle, offset: 0)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    func setModel(taskDispaly: TaskDisplay) {
        self.lblTitle.text = taskDispaly.taskType
        self.lblSubtitle.text = "Today at \(taskDispaly.date.toStringCurrentRegionShortTime())"
        self.imgTask.image = taskDispaly.image
    }
    
    static func height()->CGFloat {
        return CGFloat(70)
    }
}
