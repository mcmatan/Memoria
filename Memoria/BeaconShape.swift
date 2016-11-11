//
//  Draw.swift
//  Memoria
//
//  Created by Matan Cohen on 17/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class NearableShape: UIView {
    var lineColor = UIColor.black
    var shapeBackgroundColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rect: CGRect, backgroundColor: UIColor, lineColor: UIColor) {
        self.lineColor = lineColor
        self.shapeBackgroundColor = backgroundColor
        super.init(frame: rect)
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        _ = rect.height
        _ = rect.width
        let color:UIColor = self.lineColor
        
        let bpath = UIBezierPath()
        
        bpath.move(to: CGPoint(x: self.frame.size.width * 0.4, y: 0))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 0.8, y: self.frame.size.height * 0.1))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 1, y: self.frame.size.height * 0.3))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 0.9, y: self.frame.size.height * 0.8))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 0.4, y: self.frame.size.height * 1))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.8))
        bpath.addLine(to: CGPoint(x: 0, y: self.frame.size.height * 0.5))
        bpath.addLine(to: CGPoint(x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.2))
        bpath.addLine(to: CGPoint(x: self.frame.size.width *  0.4, y: 0))
        
        color.set()
        bpath.stroke()
        
        let fillLayer = CAShapeLayer();
        fillLayer.path = bpath.cgPath;
        fillLayer.fillColor = self.shapeBackgroundColor.cgColor
        fillLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(fillLayer)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor.clear
    }
}
