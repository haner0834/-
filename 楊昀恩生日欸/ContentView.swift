//
//  ContentView.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @StateObject var viewModel = ViewModel()
    @State private var isTapped: Bool = false
    
    let herBirthday = DateComponents(year: 2024, month: 2, day: 25, hour: 0, minute: 0, second: 0)
    
    var isAbleToShowGreeting: Bool {
        let isTodayHerBirthday = globalViewModel.isTodayHerBD()
        
        let gapToBirthday = globalViewModel.gap
        let isHerBDPassed: Bool = globalViewModel.isDayPassed(gap: gapToBirthday)
        
        return isTodayHerBirthday || isHerBDPassed
    }
    
    var body: some View {
        VStack {
            Button("push notification") {
                let date = DateComponents(month: 2, day: 24, hour: 20, minute: 25)
                viewModel.pushNotification(on: date, title: "test", body: "hello", id: "testingId")
            }
            
            if isAbleToShowGreeting {
                if !isTapped {
                    BirthdayCard(isTapped: $isTapped)
                        .transition(.offset(CGSize(width: 0, height: -20)))
                }else {
                    CardContent(isTapped: $isTapped)
                }
            }else {
                WaitingForBirthday()
                    .environmentObject(globalViewModel)
            }
        }
        .onAppear(perform: viewModel.processInit)
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalViewModel())
}
