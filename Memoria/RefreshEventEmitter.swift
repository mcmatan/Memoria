//
//  ApplicationUIRefreshRate.swift
//  Memoria
//
//  Created by Matan Cohen on 12/2/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class RefreshEventEmitter {
    var refeshTimer: Timer?
    let refresTimeInterval: TimeInterval = 60.0
    init() {
        self.setupTimer()
    }
    
    func setupTimer() {
        self.refeshTimer = Timer.scheduledTimer(withTimeInterval: refresTimeInterval, repeats: true, block: { timer in
            self.fireRefreshEvent()
        })
    }
    
    func fireRefreshEvent() {
        Events.shared.refreshInterval.emit(())
    }
    
}
