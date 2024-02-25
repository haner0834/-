//
//  Tips.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/21.
//

import Foundation
import SwiftUI
import TipKit

struct RemindDonotOpenAppTip: Tip {
    static let event = Event(id: "remindDonotOpenAppTip")
    
    var title: Text {
        Text("記得不要開app")
    }
    
    var message: Text? {
        Text("如果你想要在生日當天收到你開啟幾次就傳幾次的通知，不要在當天（24到25的）12.00開著app，不然會收不到通知")
    }
    
    var rules: [Rule] {
        #Rule(Self.event) { event in
            event.donations.count >= 1
        }
        
        #Rule(Self.event) { event in
            event.donations.count < 2
        }
    }
}
