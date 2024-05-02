//
//  HomeViewModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/28.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var isCountdownForBD = false
    @Published var isTapped: Bool = true
    @Published var isAbleToShowGreeting = false
    
    @Published var displayType: [DisplayType] = []
    @Published var scrollID: DisplayType? = .countdown
    
    ///Record how many times screen has been tapped
    @Published var tapTimes: Int = 0
    var nonsense: String {
        let nonsenses = NonsenseContext.smartHumanSaid
        
        for nonsense in nonsenses where nonsense.range ~= tapTimes { return nonsense.content }
        
        return ""
    }
    
    @Published var isCAPCountdownEnabled = false
    @Published var isGraduationPassed: Bool = false
    let graduationDate = DateComponents(year: 2024, month: 6, day: 8, hour: 0, minute: 0, second: 0)
    let calendar = Calendar.current
    let userDefault = UserDefaults.standard
}
