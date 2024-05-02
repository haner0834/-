//
//  ContentViewModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/21.
//

import Foundation
import SwiftUI

extension ContentView {
    final class ViewModel: ObservableObject {
        let userDefault = UserDefaults.standard
        
        func requestNotificaltion() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All Set!")
                }else if let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        func sendNotificatonOnHerBD() {
            let herBirthday = DateComponents(year: 2025, month: 2, day: 25, hour: 0, minute: 0, second: 0)
            
            let content = UNMutableNotificationContent()
                content.title = "林禹澔"
                content.body = "生日快樂ㄟ 來看看你的生日禮物裡面有什麼ㄅ"
                content.sound = .default
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: herBirthday, repeats: false)
            
            let id = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        func pushNotification(on date: DateComponents, title: String, body: String, id: String = UUID().uuidString) {
            let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        func processInit() {
            requestNotificaltion()
            
            sendNotificatonOnHerBD()
            let key = UserDefaultKeys.notificationPushTimes
            let userDefault = UserDefaults.standard
            let pushTimes = userDefault.integer(forKey: key)
            userDefault.set(pushTimes + 1, forKey: key)
            
            let examDay = DateComponents(year: 2024, month: 2, day: 22, hour: 5, minute: 30, second: 0)
            pushNotification(on: examDay, title: "誰ㄚ那麼有心還傳這個", body: "模考好玩嗎:D", id: "mockExam")
            
            let examFinishedTime = DateComponents(year: 2024, month: 2, day: 22, hour: 11, minute: 50, second: 0)
            pushNotification(on: examFinishedTime, title: "終於考完ㄌ", body: "考完了欸好爽", id: "mockExamFinished")
            
            let dayBeforeHerBirthday = DateComponents(year: 2024, month: 2, day: 24, hour: 5, minute: 30, second: 0)
            pushNotification(on: dayBeforeHerBirthday, title: "剩最後一天ㄌ", body: "期不期待明天有什麼東西👀", id: "dayBeforeHerBirthday")
            
            let dayBeforeHerBirthday1 = DateComponents(year: 2024, month: 2, day: 24, hour: 16, minute: 7, second: 11)
            pushNotification(on: dayBeforeHerBirthday1, title: "最後一天:D", body: "我好多話ㄛ天啊", id: "dayBeforeHerBirthday1")
            
            let dayBeforeHerBirthday2 = DateComponents(year: 2024, month: 2, day: 24, hour: 19, minute: 16, second: 11)
            pushNotification(on: dayBeforeHerBirthday2, title: "最後一天:D", body: "我好多話ㄛ天啊", id: "dayBeforeHerBirthday2")
            
            let hourBeforeHerBirthday = DateComponents(year: 2024, month: 2, day: 24, hour: 23, minute: 0, second: 34)
            pushNotification(on: hourBeforeHerBirthday, title: "最後一小時", body: "期待ㄇ", id: "hourBeforeHerBirthday")
            
            let herBirthday = DateComponents(year: 2024, month: 2, day: 25, hour: 7, minute: 16, second: 11)
            pushNotification(on: herBirthday, title: "ㄏㄟˋ", body: "還記得我ㄇ", id: "didURememberMe")
        }
    }
}
