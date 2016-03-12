//
//  TaskWarningPopUp.swift
//  Memoria
//
//  Created by Matan Cohen on 3/10/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class TaskWarningPopUp : ViewController {
    let lblYouAllreadyTook = Label()
    let lblBeCareful = Label()
    let btnYes = Button()
    let btnSoundPlaying = Button()    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imgError = ImageView(image: UIImage(named: "NotificationWarningImg"))
        self.view.addSubview(imgError)
        imgError.centerInSuperView()
        imgError.widthLayoutAs(87)
        imgError.heightLayoutAs(117)
        imgError.topToViewControllerTopLayoutGuide(self, offset: 70)
        
        self.lblYouAllreadyTook.text = "You Already took your medicine today"
        self.lblYouAllreadyTook.font = UIFont.systemFontOfSize(26)
        self.lblYouAllreadyTook.numberOfLines = 2
        self.lblYouAllreadyTook.textAlignment = NSTextAlignment.Center
        self.view .addSubview(self.lblYouAllreadyTook)
        self.lblYouAllreadyTook.topAlighnToViewBottom(imgError, offset: 23)
        self.lblYouAllreadyTook.centerHorizontalyInSuperView()
        self.lblYouAllreadyTook.leadingToSuperView(true)
        self.lblYouAllreadyTook.trailingToSuperView(true)
        
        self.lblBeCareful.text = "Be careful not to take too many."
        self.lblBeCareful.titleGray()
        self.lblBeCareful.font = UIFont.systemFontOfSize(24)
        self.lblBeCareful.textAlignment = NSTextAlignment.Center
        self.lblBeCareful.numberOfLines = 0
        self.view.addSubview(self.lblBeCareful)
        self.lblBeCareful.centerHorizontalyInSuperView()
        self.lblBeCareful.topAlighnToViewBottom(self.lblYouAllreadyTook, offset: 13)
        
        self.view.addSubview(self.btnYes)
        self.btnYes.notificiationThankYou()
        self.btnYes.centerHorizontalyInSuperView()
        self.btnYes.topAlighnToViewBottom(self.lblBeCareful, offset: 40)
        
        self.view.addSubview(self.btnSoundPlaying)
        self.btnSoundPlaying.notificiationPlayingGray()
        self.btnSoundPlaying.centerHorizontalyInSuperView()
        self.btnSoundPlaying.bottomAlighnToViewBottom(self.view, offset: -40)

    }
}