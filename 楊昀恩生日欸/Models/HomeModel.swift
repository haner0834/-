//
//  HomeModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/24.
//

import Foundation


enum DisplayType: CaseIterable {
    case countdown, birthdayGreeting, newThing, graduationBook, memories
    var text: String {
        switch self {
        case .countdown:
            return "各種倒數"
        case .birthdayGreeting:
            return "生日卡片:D"
        case .newThing:
            return "新東東"
        case .graduationBook:
            return "畢業紀念冊"
        case .memories:
            return "Memories"
        }
    }
}
