//
//  Notifications.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/21.
//

import Foundation

final class Notifications {
    let contents: [NotificationValue] = [
        .init(title: "嗨你好", message: "聽說是考試很累 :D", dateConponents: .init(year: 2024, month: 4, day: 30), id: "nonsense 1")
    ]
}

struct NotificationValue: Hashable {
    var title: String
    var message: String
    var dateConponents: DateComponents
    var id: String
}
