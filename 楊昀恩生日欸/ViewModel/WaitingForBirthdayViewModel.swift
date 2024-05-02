//
//  WaitingForBirthdayViewModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import Foundation
import SwiftUI

final class GlobalViewModel: ObservableObject {
    
    let capDay = DateComponents(year: 2024, month: 5, day: 18, hour: 0, minute: 0, second: 0)
    let herBirthday = DateComponents(year: 2025, month: 2, day: 25, hour: 0, minute: 0, second: 0)
    let calendar = Calendar.current
    
    @Published var gap = DateComponents()
    
    @Published var gapToCAP = DateComponents()
    
    @Published var stayTime: Int = 0
    
    @Published var isAbleToShowGreeting: Bool = false
    
    init() {
        updateTimer()
    }
    
    func updateTimer() {
        guard let birthday = calendar.date(from: herBirthday) else { return }
        guard let capDay = calendar.date(from: capDay) else { return }
        
        withAnimation {
            stayTime += 1
            
            gap = getGap(toDate: birthday)
            
            gapToCAP = getGap(toDate: capDay)
        }
    }
    
    func getGap(toDate date: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: date)
        
        return components
    }
    
    func isDayPassed(gap: DateComponents) -> Bool {
        guard let year = gap.year,
              let month = gap.month,
              let day = gap.day,
              let hour = gap.hour,
              let minute = gap.minute,
              let second = gap.second else { return false}
        
        return year <= 0 && month <= 0 && day <= 0 && hour <= 0 && minute <= 0 && second <= 0
    }
    
    func processUpdateGap(forGap gap: DateComponents) {
        let components =  DateComponents(year: gap.year!,
                                         month: gap.month!,
                                         day: gap.day!,
                                         hour: gap.hour!,
                                         minute: gap.minute!,
                                         second: gap.second!)
        
//        if !isDayPassed(gap: gap) && !isTodayHerBD() {
            updateTimer()
            isAbleToShowGreeting = isDayPassed(gap: components)
//        }
    }
    
    func isTodayHerBD() -> Bool {
        let today = calendar.dateComponents([.month, .day], from: Date())
        return today.month == herBirthday.month && today.day == herBirthday.day
    }
}

extension DateComponents {
    var now: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: .now)
    }
    
    func isDayPassed(gap: DateComponents) -> Bool {
        guard let year = gap.year,
              let month = gap.month,
              let day = gap.day,
              let hour = gap.hour,
              let minute = gap.minute,
              let second = gap.second else { return false }
        
        return year <= 0 && month <= 0 && day <= 0 && hour <= 0 && minute <= 0 && second <= 0
    }
    
    func isPassed(using calendar: Calendar = .current) -> Bool {
        ///Example:
        ///self:  2024/6/8
        ///now: 2024/5/2
        guard let year = self.year,
              let month = self.month,
              let day = self.day else { return false }
        
        let components: Set<Calendar.Component> = [.year, .month, .day]
        let now = calendar.dateComponents(components, from: .now)
        
       
        return now.year! >= year && now.month! >= month && now.day! > day
    }
    
    func getGap(to date: Date = .now,
                components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second],
                using calendar: Calendar = .current) -> DateComponents {
        
        guard let dateComponents = calendar.date(from: self) else { return .init() }
        let gap = calendar.dateComponents(components, from: dateComponents, to: date)
        
        return gap
    }
}
