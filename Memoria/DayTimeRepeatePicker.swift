//
//  DayTimeRepeatePicker.swift
//  AdvancedDayAndTimePicker
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import ATHMultiSelectionSegmentedControl

class DayTimeRepeatePicker: UIView {
    func getSelected()->(times: [Time], days: [Day]) {
        
        let days = self.daySegmentedControl.selectedSegmentIndices.map { dayNumber in
            return Day(rawValue: dayNumber)
        }
        return (self.selectedTimes, days as! [Day])
    }
    
    private var selectedTimes = [Time]()
    private let daySegmentedControl = MultiSelectionSegmentedControl(items: Day.allStringValues())
    private let timesStack =  UIStackView()
    private let btnAddTime = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {

        self.timesStack.spacing = 10
        self.btnAddTime.backgroundColor = UIColor.blue
        self.timesStack.axis = UILayoutConstraintAxis.vertical
        self.addSubview(self.daySegmentedControl)
        self.addSubview(self.btnAddTime)
        self.addSubview(self.timesStack)
        
        self.daySegmentedControl.topAlighnToViewTop(self, offset: 10)
        self.daySegmentedControl.leadingToSuperView(true)
        self.daySegmentedControl.trailingToSuperView(true)
        self.daySegmentedControl.setHeightAs(30)
        
        self.timesStack.centerHorizontlyInSuperView()
        self.timesStack.topAlighnToViewBottom(self.daySegmentedControl, offset: 20)
        
        self.btnAddTime.setTitle(" +Add time ", for: UIControlState.normal)
        self.btnAddTime.topAlighnToViewBottom(self.timesStack, offset: 20)
        self.btnAddTime.addTarget(self, action: #selector(btnAddTimePress), for: UIControlEvents.touchUpInside)
        self.btnAddTime.centerHorizontlyInSuperView()
        
        self.bottomAlighnToViewBottom(self.btnAddTime, offset: 10)
        self.backgroundColor = UIColor.lightGray
        
        self.corners()
    }
    
    func corners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3.0
    
        self.btnAddTime.layer.masksToBounds = true
        self.btnAddTime.layer.cornerRadius = 3.0
    }
    
    func timePicked(date: Date) {
        let time = Time(date: date)
        self.selectedTimes.append(time)
        self.addTimeStringToStack(timeString: time.timeString)
    }
    
    func addTimeStringToStack(timeString: String) {
        let lbl = UILabel()
        lbl.text = timeString
        self.timesStack.addArrangedSubview(lbl)
    }
    
    func btnAddTimePress() {
        let txt = "Choose time"
        let datePicker = DatePickerDialog()
        
        datePicker.show(txt, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), datePickerMode: UIDatePickerMode.time) { (date) in
            self.timePicked(date: date)
        }
    }
    
}
