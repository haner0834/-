//
//  WaitingForBirthdayViewModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import Foundation
import SwiftUI

final class GlobalViewModel: ObservableObject {
    
    let herBirthday = DateComponents(year: 2024, month: 2, day: 25, hour: 0,minute: 0, second: 0)
    let calendar = Calendar.current
    
    @Published var gap = DateComponents()
    
    @Published var stayTime: Int = 0
    
    @Published var isAbleToShowGreeting: Bool = false
    
    init() {
        updateTimer()
    }
    
    func updateTimer() {
        guard let birthday = calendar.date(from: herBirthday) else { return }
        
        withAnimation {
            stayTime += 1
            
            gap = getGapToBirthday(bd: birthday)
        }
    }
    
    func getGapToBirthday(bd: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: bd)
        
        return components
    }
    
    func isDayPassed(gap: DateComponents) -> Bool {
        if let year = gap.year, let month = gap.month, let day = gap.day, let hour = gap.hour, let minute = gap.minute, let second = gap.second {
            return year <= 0 && month <= 0 && day <= 0 && hour <= 0 && minute <= 0 && second <= 0
        }
        return false
    }
    
    func processUpdateGap() {
        let components =  DateComponents(year: gap.year!,
                                         month: gap.month!,
                                         day: gap.day!,
                                         hour: gap.hour!,
                                         minute: gap.minute!,
                                         second: gap.second!)
        
        if !isDayPassed(gap: gap) && !isTodayHerBD() {
            updateTimer()
            isAbleToShowGreeting = isDayPassed(gap: components)
        }
    }
    
    func isTodayHerBD() -> Bool {
        let today = calendar.dateComponents([.month, .day], from: Date())
        return today.month == herBirthday.month && today.day == herBirthday.day
    }
}

